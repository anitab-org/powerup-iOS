package com.example.powerupapp;

public class Scenario {

	private Integer id;
	private String scenarioName;
	private String timestamp;
	private String asker;
	private Integer avatar;
	private Integer firstQId;
	private Integer nextScenarioId;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer iD) {
		id = iD;
	}
	public String getScenarioName() {
		return scenarioName;
	}
	public void setScenarioName(String scenarioName) {
		this.scenarioName = scenarioName;
	}
	public String getTimestamp() {
		return timestamp;
	}
	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}
	public String getAsker() {
		return asker;
	}
	public void setAsker(String asker) {
		this.asker = asker;
	}
	public Integer getAvatar() {
		return avatar;
	}
	public void setAvatar(Integer avatar) {
		this.avatar = avatar;
	}
	public Integer getFirstQId() {
		return firstQId;
	}
	public void setFirstQId(Integer firstQId) {
		this.firstQId = firstQId;
	}
	public Integer getNextScenarioId() {
		return nextScenarioId;
	}
	public void setNextScenarioId(Integer nextScenarioId) {
		this.nextScenarioId = nextScenarioId;
	}
}
