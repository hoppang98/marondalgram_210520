package com.marondalgram.user;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.marondalgram.common.EncryptUtils;
import com.marondalgram.user.bo.UserBO;
import com.marondalgram.user.model.User;

@RequestMapping("/user")
@RestController
public class UserRestController {
	
	@Autowired
	private UserBO userBO;
	/**
	 * 아이디 중복확인 체크
	 * @param loginId
	 * @return
	 */
	@RequestMapping("/is_duplicated_id")
	public Map<String, Boolean> isDuplicatedId(
			@RequestParam("loginId") String loginId) {
		
		// 중복여부에 대한 결과 Map 생성
		 Map<String, Boolean> result = new HashMap<>();
		 result.put("result", userBO.existLoginId(loginId)); // loginId 중복 여부 DB 조회
		
		//return Map
		return result;
	}
	
	@RequestMapping("/sign_up")
	public Map<String, Object> signUp(
			@RequestParam("loginId") String loginId,
			@RequestParam("password") String password,
			@RequestParam("name") String name,
			@RequestParam("email") String email) {
		
		String encryptPassword = EncryptUtils.md5(password);
		int row = userBO.insertUser(loginId, encryptPassword, name, email);
		
		Map<String, Object> result = new HashMap<>();
		if (row == 1) {
			result.put("result", "success");
		} else {
			result.put("error", "입력 실패");
		}
		return result;
	}
	
	@RequestMapping("/sign_in")
	public Map<String, Object> signIn(
			@RequestParam("loginId") String loginId,
			@RequestParam("password") String password,
			HttpServletRequest request) {
		
		String encryptPassword = EncryptUtils.md5(password);
		User user = userBO.getUser(loginId, encryptPassword);
		
		Map<String, Object> result = new HashMap<>();
		if (user != null) {
			result.put("result", "success");
			// 로그인 처리 - 세션에 저장(로그인 상태를 유지한다)
			HttpSession session = request.getSession();
			session.setAttribute("userLoginId", user.getLoginId());
			session.setAttribute("userName", user.getName());	
			session.setAttribute("userId", user.getId());	
		} else {
			result.put("error", "입력 실패");
		}
		return result;
	}
}
