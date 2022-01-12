package lastpunch.workspace.common;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
public enum ServerCode{
    AUTH(StatusCode.AUTH_OK),
    WORKSPACE(StatusCode.WORKSPACE_OK);

    private StatusCode okStatus;

    public HttpStatus getOkHttpStatus() {
        return okStatus.getStatus();
    }

    public String getOkServerCode() {
        return okStatus.getCode();
    }
}
