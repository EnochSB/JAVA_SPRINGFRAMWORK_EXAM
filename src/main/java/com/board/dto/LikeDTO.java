package com.board.dto;

import java.util.Date;

public class LikeDTO {
	private int seqno;
	private String userid;
	private String mylikecheck;
	private String mydislikecheck;
	private Date likedate;
	private Date dislikedate;
	
	public int getSeqno() {
		return seqno;
	}
	public void setSeqno(int seqno) {
		this.seqno = seqno;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getMylikecheck() {
		return mylikecheck;
	}
	public void setMylikecheck(String mylikecheck) {
		this.mylikecheck = mylikecheck;
	}
	public String getMydislikecheck() {
		return mydislikecheck;
	}
	public void setMydislikecheck(String mydislikecheck) {
		this.mydislikecheck = mydislikecheck;
	}
	public Date getLikedate() {
		return likedate;
	}
	public void setLikedate(Date likedate) {
		this.likedate = likedate;
	}
	public Date getDislikedate() {
		return dislikedate;
	}
	public void setDislikedate(Date dislikedate) {
		this.dislikedate = dislikedate;
	}
	
}
