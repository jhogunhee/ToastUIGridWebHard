package kr.or.vo;
import lombok.Data;

@Data
public class FileVO implements Comparable<FileVO>{
	String fileName;
	String type;
	String modifyDate;
	String capacity;
	
	@Override
	public int compareTo(FileVO o) {
		return o.type.compareTo(this.type);
	}
}
