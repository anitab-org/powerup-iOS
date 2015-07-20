package com.example.powerupapp;

import com.example.powerupapp.db.DatabaseHandler;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class Map extends Activity {

	private DatabaseHandler mDbHandler;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setmDbHandler(new DatabaseHandler(this));
		getmDbHandler().open();
		setContentView(R.layout.gamemap);

		Button continueButton = (Button) findViewById(R.id.button1);
		continueButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent myIntent = new Intent(Map.this, Game.class);
				startActivityForResult(myIntent, 0);
			}
		});
		Button house = (Button) findViewById(R.id.button2);
		house.setOnClickListener(onClickListener);

		Button boyfriend = (Button) findViewById(R.id.button3);
		boyfriend.setOnClickListener(onClickListener);

		Button hospital = (Button) findViewById(R.id.button4);
		hospital.setOnClickListener(onClickListener);

		Button school = (Button) findViewById(R.id.button5);
		school.setOnClickListener(onClickListener);

	}

	private OnClickListener onClickListener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			Button b = (Button) v;
			if (getmDbHandler().setSessionId(b.getText().toString())) {
				Intent myIntent = new Intent(Map.this, Game.class);
				startActivityForResult(myIntent, 0);
			} else {
				Intent myIntent = new Intent(Map.this, CompletedScene.class);
				startActivityForResult(myIntent, 0);
			}
		}
	};

	public DatabaseHandler getmDbHandler() {
		return mDbHandler;
	}

	public void setmDbHandler(DatabaseHandler mDbHandler) {
		this.mDbHandler = mDbHandler;
	}
}
