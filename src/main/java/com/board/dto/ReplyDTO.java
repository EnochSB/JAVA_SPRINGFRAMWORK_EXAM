package com.board.dto;

import java.util.Date;

public class ReplyDTO {
	private int replyseqno;
	private int seqno;
	private String replywriter;
	private String replycontent;
	private Date replyregdate;
	private String userid;
	
	public int getReplyseqno() {
		return replyseqno;
	}
	public void setReplyseqno(int replyseqno) {
		this.replyseqno = replyseqno;
	}
	public int getSeqno() {
		return seqno;
	}
	public void setSeqno(int seqno) {
		this.seqno = seqno;
	}
	public String getReplywriter() {
		return replywriter;
	}
	public void setReplywriter(String replywriter) {
		this.replywriter = replywriter;
	}
	public String getReplycontent() {
		return replycontent;
	}
	public void setReplycontent(String replycontent) {
		this.replycontent = replycontent;
	}
	public Date getReplyregdate() {
		return replyregdate;
	}
	public void setReplyregdate(Date replyregdate) {
		this.replyregdate = replyregdate;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	
}
