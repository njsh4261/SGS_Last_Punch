# Config

## 코딩 스타일
- Java 코딩 스타일
  - `LastPunchStyle.xml`: Intellij에서 사용할 수 있는 코딩 스타일 설정 파일
  - [Google Java Code Style](https://google.github.io/styleguide/javaguide.html) 을 참조했음
    ([번역본](https://newwisdom.tistory.com/96))
  - `File - Settings - Editor - Code Style - Java`에서 `Scheme` 옆의 톱니바퀴 아이콘 클릭,
    `Import Scheme - IntelliJ IDEA code style scheme` 선택하여 xml 파일 불러와서 적용 가능
  - **NOTE:** [구글 스타일 가이드 깃 repo에서 제공하는 파일](https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml) 을
    기반으로 했는데, 정작 원본 xml 파일에는 누락된 코드 컨벤션(ex. 탭 및 들여쓰기, 줄바꿈 등)이 많이 있어서
    Intellij 통해서 임의로 수정한 xml 파일을 배포합니다.
    - 수정해야 하거나 수정하고 싶은 코딩 스타일이 있다면 깃 이슈 및 PR 올려주시면 좋습니다.

## 
