package com.board.dto;

public class AddressDTO {
	private String zipcode;
	private String province;
	private String road; 
	private String building;
	private String oldaddr;
	
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getRoad() {
		return road;
	}
	public void setRoad(String road) {
		this.road = road;
	}
	public String getBuilding() {
		return building;
	}
	public void setBuilding(String building) {
		this.building = building;
	}
	public String getOldaddr() {
		return oldaddr;
	}
	public void setOldaddr(String oldaddr) {
		this.oldaddr = oldaddr;
	}
}
