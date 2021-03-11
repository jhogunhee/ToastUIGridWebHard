package kr.or.vo;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
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
