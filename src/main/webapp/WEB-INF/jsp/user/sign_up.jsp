<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<h2 class="m-3 font-weight-bold">회원가입</h2>
<div class="d-flex justify-content-center">
	<div class="sign-up-box">
		<form id="signUpForm" method="post" action="/user/sign_up">
			<span class="sign-up-subject">ID</span>
			<%-- 인풋 옆에 중복확인 버튼을 옆에 붙이기 위해 div 만들고 d-flex --%>
			<div class="d-flex ml-3 mt-3">
				<input type="text" name="loginId" class="form-control col-6" placeholder="ID를 입력해주세요">
				<button type="button" id="loginIdCheckBtn" class="btn btn-success">중복확인</button>
			</div>
			
			<%-- 아이디 체크 결과 --%>
			<div class="ml-3 mb-3">
				<div id="idCheckLength" class="small text-danger d-none">ID를 4자 이상 입력해주세요.</div>
				<div id="idCheckDuplicated" class="small text-danger d-none">이미 사용중인 ID입니다.</div>
				<div id="idCheckOk" class="small text-success d-none">사용 가능한 ID 입니다.</div>
			</div>
			
			<span class="sign-up-subject">Password</span>
			<div class="m-3">
				<input type="password" name="password" class="form-control col-6" placeholder="비밀번호를 입력하세요">
			</div>

			<span class="sign-up-subject">Confirm password</span>
			<div class="m-3">
				<input type="password" name="confirmPassword" class="form-control col-6" placeholder="비밀번호를 입력하세요">
			</div>

			<span class="sign-up-subject">이름</span>
			<div class="m-3">
				<input type="text" name="name" class="form-control col-6" placeholder="이름을 입력하세요">
			</div>

			<span class="sign-up-subject">이메일</span>
			<div class="m-3">
				<input type="text" name="email" class="form-control col-6" placeholder="이메일을 입력하세요">
			</div>
			
			<br>
			<div class="d-flex justify-content-center m-3">
				<button type="button" id="signUpBtn" class="btn btn-info">가입하기</button>
			</div>
		</form>
	</div>
</div>

<script>
	$(document).ready(function() {
		$('#loginIdCheckBtn').on('click', function(e){
			let loginId = $('input[name=loginId]').val().trim();
			//alert(loginId)
			// idCheckLength, idCheckDuplicated, idCheckOk
			if (loginId.length < 4) {
				$('#idCheckLength').removeClass('d-none'); // 경고문구 노출
				$('idCheckDuplicated').addClass('d-none'); // 숨김
				$('idCheckOk').addClass('d-none'); // 숨김
				return;
			}
			
			//ajax 서버 호출(중복여부 확인)
			$.ajax({
				type: 'get'
				, url: '/user/is_duplicated_id'
				, data: {"loginId" : loginId}
				, success : function(data) { // 성공하면 실행
					if (data.result == true) {
						//중복이면
						$('#idCheckLength').addClass('d-none'); // 경고문구 노출
						$('#idCheckDuplicated').removeClass('d-none'); // 숨김
						$('#idCheckOk').addClass('d-none'); // 숨김
					} else {
						// 중복이 아니면 => 가능
						$('#idCheckLength').addClass('d-none'); // 경고문구 노출
						$('#idCheckDuplicated').addClass('d-none'); // 숨김
						$('#idCheckOk').removeClass('d-none'); // 숨김
					}
				}, error: function(e) {
					alert("아아디 중복확인에 실패했습니다. 관리자에게 문의해주세요.");
				}
			});
		});
		
		// signUpBtn 회원가입 버튼클릭
		
	});
</script>