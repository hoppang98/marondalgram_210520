<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex justify-content-center">
	<div class="contents-box">
		
		<%-- 글쓰기 영역 - 로그인 된 상태에서만 보임 --%>
		<c:if test="${not empty userId}">
			<%-- textarea의 테두리는 없애고 div에 테두리를 준다. --%>
			<div class="write-box border rounded m-3">
				<textarea id="writeTextArea" placeholder="내용을 입력해주세요" class="w-100 border-0"></textarea>
				
				<%-- 이미지 업로드를 위한 아이콘과 업로드 버튼을 한 행에 멀리 떨어뜨리기 위한 div --%>
				<div class="d-flex justify-content-between">
					<div class="file-upload d-flex">
						<%-- file 태그는 숨겨두고 이미지를 클릭하면 file 태그를 클릭한 것처럼 이벤트를 줄 것이다. --%>
						<input type="file" id="file" class="d-none" accept=".gif, .jpg, .png, .jpeg">
						<%-- 이미지에 마우스 올리면 마우스커서가 링크 커서가 변하도록 a 태그 사용 --%>
						<a href="#" id="fileUploadBtn"><img width="35" src="https://cdn4.iconfinder.com/data/icons/ionicons/512/icon-image-512.png"></a>

						<%-- 업로드 된 임시 파일 이름 저장될 곳 --%>
						<div id="fileName" class="ml-2">
						</div>
					</div>
					<button id="writeBtn" class="btn btn-info">게시</button>
				</div>
			</div>
		</c:if>
		
		<%-- 타임라인 영역 --%>
		<%-- my: margin 위아래(y축) --%>
		<div class="timeline-box my-5">
			<%-- 반복문 --%>
			<c:forEach var="content" items="${contentList}">
			
				<%-- 카드 하나하나마다 영역을 border로 나눔 --%>
				<div class="card border rounded mt-3">
					
					<%-- 글쓴이 아이디 및 ... 버튼(삭제) : 이 둘을 한 행에 멀리 떨어뜨려 나타내기 위해 d-flex, between --%>
					<div class="p-2 d-flex justify-content-between">
						<span class="font-weight-bold">${content.post.userName}</span>
						
						<%-- 클릭할 수 있는 ... 버튼 이미지 --%>
						<%-- 로그인 된 사용자가 작성한 경우에만 버튼 노출 --%>
						<%-- 삭제될 글번호를 modal창에 넣기 위해 더보기 클릭시 이벤트에서 심어준다. --%>
						<c:if test="${userName eq content.post.userName}">
							<a href="#" class="more-btn" data-toggle="modal" data-target="#moreModal" data-post-id="${content.post.id}">
								<img src="https://www.iconninja.com/files/860/824/939/more-icon.png" width="30">
							</a>
						</c:if>
					</div>
					
					<%-- 카드 이미지 --%>
					<div class="card-img">
						<%-- 이미지가 존재하는 경우에만 노출 --%>
						<c:if test="${not empty content.post.imagePath}">
							<img src="${content.post.imagePath}" class="w-100" alt="이미지">
						</c:if>
					</div>
					
					<%-- 좋아요 --%>
					<div class="card-like m-3">
						<a href="#" class="like-btn" data-post-id="${content.post.id}" data-user-id="${userId}">
							<%-- 좋아요 해제 상태 --%>
							<c:if test="${content.filledLike eq false}">
								<img src="https://www.iconninja.com/files/214/518/441/heart-icon.png" width="18px" height="18px">
							</c:if>
							<%-- 좋아요 상태 --%>
							<c:if test="${content.filledLike eq true}">
								<img src="https://www.iconninja.com/files/527/809/128/heart-icon.png" width="18px" height="18px">
							</c:if>
						</a>
						<a href="#">좋아요 ${content.likeCount}개</a>
					</div>
					
					<%-- 글(Post) --%>
					<div class="card-post m-3">
						<span class="font-weight-bold">${content.post.userName}</span> 
						<span>
							${content.post.content}
						</span>
					</div>
					
					<%-- 댓글(Comment) --%>
					
					<%-- "댓글" - 댓글이 있는 경우에만 댓글 영역 노출 --%>
					<c:if test="${not empty content.commentList}">
						<div class="card-comment-desc border-bottom">
							<div class="ml-3 mb-1 font-weight-bold">댓글</div>
						</div>
						<div class="card-comment-list m-2">
							<%-- 댓글 목록 --%>
							<c:forEach var="comment" items="${content.commentList}">
								<div class="card-comment m-1">
									<span class="font-weight-bold">${comment.userName} : </span>
									<span>${comment.content}</span>
									
									<%-- 댓글쓴이가 본인이면 삭제버튼 노출 --%>
									<c:if test="${userName eq comment.userName}">
										<a href="#" class="commentDelBtn" data-comment-id="${comment.id}">
											<img src="https://www.iconninja.com/files/603/22/506/x-icon.png" width="10px" height="10px">
										</a>
									</c:if>
								</div>
							</c:forEach>
						</div>
					</c:if>
					
					<%-- 댓글 쓰기 --%>
					<%-- 로그인 된 상태에서만 쓸 수 있다. --%>
					<c:if test="${not empty userId}">
						<div class="comment-write d-flex border-top mt-2">
							<input type="text" id="commentText${content.post.id}" class="form-control border-0 mr-2" placeholder="댓글 달기"/> 
							<button type="button" class="btn btn-light commentBtn" data-post-id="${content.post.id}">게시</button>
						</div>
					</c:if>
				</div>
			</c:forEach>
		</div>
	</div>
</div>

<script>
$(document).ready(function(){
	// 파일업로드 이미지 버튼 클릭 -> 파일 선택 창이 뜬다
	$('#fileUploadBtn').on('click', function(e){
		e.prevenrDefault(); // 제일 위로 올라가는 동작 중지
		$('#file').click(); // 사용자가 input file을 클릭한 것과 같은 동작
	});
	
	// 사용자가 파일을 선택했을 때 => 파일명을 옆에 노출시킴
	$('#file').on('change', function(e){
		let fileName = e.target.files[0].name; // 업로드된 파일의 이름을 변수에 저장
		console.log("fileName:" + fileName)
		
		let fileNameArr = fileName.split('.');
		if (fileNameArr[fileNameArr.length - 1] != 'png'
				&& fileNameArr[fileNameArr.length - 1] != 'gif'
				&& fileNameArr[fileNameArr.length - 1] != 'jpg'
				&& fileNameArr[fileNameArr.length - 1] != 'jpeg') {
			alert("이미지 파일만 업로드 할 수 있습니다.");
			$(this).val(''); // 잘못 올라간 파일을 지워준다
			$('#fileName').text(''); // 잘못 올라간 파일명도 지워준다
			return;
		}
		
		$('#fileName').text(fileName); // 파일명을 div 사이에 노출시킨다.
		
	});
});
</script>