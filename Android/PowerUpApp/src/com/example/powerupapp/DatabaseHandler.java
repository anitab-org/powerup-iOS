package com.example.powerupapp;

import java.util.List;

import android.content.Context;
import android.database.Cursor;

public class DatabaseHandler extends AbstractDbAdapter {

	public DatabaseHandler(Context ctx) {
		super(ctx);
		ctx.getAssets();
	}

	public void getAllAnswer(List<Answer> answers, Integer qId) {
		String selectQuery = "SELECT  * FROM Answer WHERE QID = " + qId;
		Cursor cursor = mDb.rawQuery(selectQuery, null);
		answers.clear();
		if (cursor.moveToFirst()) {
			do {
				Answer ans = new Answer();
				ans.setAId(cursor.getInt(0));
				ans.setQId(cursor.getInt(1));
				ans.setADes(cursor.getString(2));
				ans.setNextQId(cursor.getInt(3));
				ans.setPoint(cursor.getInt(4));
				answers.add(ans);
			} while (cursor.moveToNext());
		}
	}

	public Question getCurrentQuestion() {
		String selectQuery = "SELECT  * FROM Question WHERE QID = "
				+ SessionHistory.currQID;
		Cursor cursor = mDb.rawQuery(selectQuery, null);
		if (cursor.moveToFirst()) {
			Question que = new Question();
			que.setQId(cursor.getInt(0));
			que.setScenarioId(cursor.getInt(1));
			que.setQDes(cursor.getString(2));
			return que;
		}
		return null;
	}

	public Scenario getScenario() {
		String selectQuery = "SELECT  * FROM Scenario WHERE ID = "
				+ SessionHistory.currSessionID;
		Cursor cursor = mDb.rawQuery(selectQuery, null);
		if (cursor.moveToFirst()) {
			Scenario scene = new Scenario();
			scene.setId(cursor.getInt(0));
			scene.setScenarioName(cursor.getString(1));
			scene.setTimestamp(cursor.getString(2));
			scene.setAsker(cursor.getString(3));
			scene.setAvatar(cursor.getInt(4));
			scene.setFirstQId(cursor.getInt(5));
			scene.setNextScenarioId(cursor.getInt(6));
			return scene;
		}
		return null;
	}
}