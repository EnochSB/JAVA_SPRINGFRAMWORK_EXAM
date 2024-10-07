package com.board.dto;

import java.util.Date;

public class MemberLogDTO {
	private String userid;
	private Date inouttime;
	private String status;
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public Date getInouttime() {
		return inouttime;
	}
	public void setInouttime(Date inouttime) {
		this.inouttime = inouttime;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}
