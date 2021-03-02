package kr.or.controller;

import java.io.File;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
	public ArrayList<FileVO> getFileList() {
		// 1. 해야 할일 path 경로를 설정한다
		String path = "d:";

		// 2. 그 경로의 파일명, 수정일자, 파일 타입, 파일용량을 가져온다. 
		File chkDir = new File(path);

		if(!chkDir.isDirectory()) {
			chkDir.mkdirs();
		}

		ArrayList<FileVO> fileList = new ArrayList<>();
		File[] fileArray = chkDir.listFiles();
		
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
	
	@GetMapping("getFileDownload")
	public ModelAndView getFileDownload(@RequestParam Map<String, Object> map) throws Exception {
		String path = "d:" + File.separator + map.get("FILE_NAME");
		File downloadFile = new File(path);
		
		return new ModelAndView("downloadView", "downloadFile", downloadFile);
	}

}