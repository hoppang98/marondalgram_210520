package com.marondalgram.timeline.model;

import java.util.List;

public class ContentView {
	// 글 1개
	private Post post;
	
	// 댓글 n개
	private List<Comment> commentList;
	
	//내가 한 좋아요
	private boolean likeYn; // true면 좋아요, false면 좋아요 해제
	
	// 좋아요 총 개수
	private int likeCount;
}
