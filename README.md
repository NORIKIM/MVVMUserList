# UserList

Github OpenAPI를 이용하여 User 리스트를 검색
● Github OAuth :
https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps
● OpenAPI : https://docs.github.com/en/rest/reference/search#search-users
● Pattern : MVVM
● 사용 라이브러리 : Then, Moya
● Github Login을 통하여 AccessToken을 얻어 Open API 사용

### 기능
1. 유저의 이름 검색 후 검색 버튼 클릭시 유저 검색
2. 검색된 유저리스트를 표시
3. 검색된 유저가 없는 경우 검색된 유저가 없다는 Empty화면 표시
4. 아이템 선택시 해당 유저의 URL로 이동
5. Paging 처리
