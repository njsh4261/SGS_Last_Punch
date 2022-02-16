package lastpunch.workspace.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

// response 출력 포맷을 위한 wrapper class
@Getter
@AllArgsConstructor
public class Members{
    private List<?> content;
}
