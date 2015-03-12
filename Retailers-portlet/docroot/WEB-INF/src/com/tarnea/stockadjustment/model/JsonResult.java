package com.tarnea.stockadjustment.model;

import java.util.LinkedHashMap;
import java.util.List;

public class JsonResult {

	private String responseMessage;
	private List<String> message;
	private List<LinkedHashMap<String,String>> orderIdList;

	public String getResponseMessage() {
		return responseMessage;
	}

	public void setResponseMessage(String responseMessage) {
		this.responseMessage = responseMessage;
	}

	public List<String> getMessage() {
		return message;
	}

	public void setMessage(List<String> message) {
		this.message = message;
	}

	public List<LinkedHashMap<String, String>> getOrderIdList() {
		return orderIdList;
	}

	public void setOrderIdList(List<LinkedHashMap<String, String>> orderIdList) {
		this.orderIdList = orderIdList;
	}
}
