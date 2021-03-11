package kr.or.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import kr.or.vo.FileVO;

@Controller
public class HomeController {

	@GetMapping("/")
	public String main() {
		return "main";
	}

	@GetMapping("getFileList")
	@ResponseBody
	public ArrayList<FileVO> getFileList(@RequestParam(required = false) String param) {
		
		// 1. 해야 할일 path 경로를 설정한다
		String path = "d:";
		
		File chkDir;
		
		if(param != null) {
			chkDir = new File(path + param);	
		} else {
			chkDir = new File(path);
		}
		
//		System.out.println(chkDir);
		if(!chkDir.isDirectory()) {
			chkDir.mkdirs();
		}

		ArrayList<FileVO> fileList = new ArrayList<>();
		File[] fileArray = chkDir.listFiles();
		
		fileList.add(new FileVO("..", "Folder", null, null));
		for (File file : fileArray) {
			String pattern = "yyyy-MM-dd aa hh:mm ";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
			DecimalFormat formatter = new DecimalFormat("###,###");
			
			FileVO vo = new FileVO();
			if(file.isDirectory()) {
				vo.setType("Folder");
			} else if(file.isFile()) {
				vo.setType("File");
				vo.setCapacity(formatter.format(file.length()));	
				vo.setModifyDate(simpleDateFormat.format(file.lastModified()));
			}
			
			vo.setFileName(file.getName());
			fileList.add(vo);
		}
		Collections.sort(fileList);

		return fileList;
	}
	
	@GetMapping("mkDirFolder")
	@ResponseBody
	public Map<String, Object> mkDirFolder(@RequestParam Map<String, Object> param) {
		Map<String, Object> map = new HashMap<>();
		
		// 1. 해야 할일 path 경로를 설정한다
		String path = "d:";
		
		File file = new File(path +  param.get("mkDirText"));
		
		if(file.isDirectory()) {
			map.put("message", "폴더가 이미 존재합니다.");
		} else {
			file.mkdirs();
		}
		
		return map;
	}
	
	@GetMapping("getFileDownload")
	public ModelAndView getFileDownload(@RequestParam Map<String, Object> map) throws Exception {
		String path = "d:" + File.separator + map.get("FILE_NAME");
		File downloadFile = new File(path);
		
		return new ModelAndView("downloadView", "downloadFile", downloadFile);
	}

	@PostMapping("upload")
	@ResponseBody
	public Map<String, Object> upload(MultipartHttpServletRequest req) {
		Map<String, Object> map = new HashMap<>();
		
		// 파일의 경로를 지정한다.
		String path = "d:" + File.separator;
		List<MultipartFile> files = req.getFiles("files");

		try {
			// d드라이브안에 업로드한 파일을 저장한다.
			for (MultipartFile mpf : files) {
				File chkDir = new File(path);

				if(!chkDir.isDirectory()) {
					chkDir.mkdirs();
				}
				FileCopyUtils.copy(mpf.getBytes(), new FileOutputStream(path + new String(mpf.getOriginalFilename().getBytes("8859_1"),"utf-8")));
			} 
		}  catch(Exception e) {
			System.out.println("error - " + e.getMessage());
			e.printStackTrace();
		}
		return map;
	}
}
