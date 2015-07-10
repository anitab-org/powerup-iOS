package com.example.powerupapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class CompletedScene extends Activity {

	private Button backToMap;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.completed_scene);
		backToMap = (Button) findViewById(R.id.button1);
		backToMap.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent myIntent = new Intent(CompletedScene.this,
						Map.class);
				startActivityForResult(myIntent, 0);
			}
		});
	}
	
}
