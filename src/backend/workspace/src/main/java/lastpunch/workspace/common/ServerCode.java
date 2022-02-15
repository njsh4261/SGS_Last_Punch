package lastpunch.workspace.common;

import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
public enum ServerCode{
    WORKSPACE(StatusCode.WORKSPACE_OK);

    private StatusCode okStatus;

    public HttpStatus getOkHttpStatus() {
        return okStatus.getStatus();
    }

    public String getOkServerCode() {
        return okStatus.getCode();
    }
}
