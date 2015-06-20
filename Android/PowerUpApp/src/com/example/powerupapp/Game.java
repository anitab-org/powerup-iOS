package com.example.powerupapp;

import com.example.powerupapp.R;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class Game extends Activity {

	private DatabaseHandler mDbHandler;
	private List<Answer> answers;
	private Question questions;
	private Scenario scene;
	private ListView mainListView;
	private TextView questionTextView;
	private ArrayAdapter<String> listAdapter;

	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setmDbHandler(new DatabaseHandler(this));
		getmDbHandler().open();
		setContentView(R.layout.pgame);
		// Find the ListView resource.
		mainListView = (ListView) findViewById(R.id.mainListView);
		questionTextView = (TextView) findViewById(R.id.editText1);
		listAdapter = new ArrayAdapter<String>(this, R.layout.simplerow,
				new ArrayList<String>());
		answers = new ArrayList<Answer>();
		
		// Update Answer, Question and Scene 
		updateQA();
		
		// Set the ArrayAdapter as the ListView's adapter.
		mainListView.setAdapter(listAdapter);
		mainListView.setOnItemClickListener(new
				AdapterView.OnItemClickListener() {
					@Override
					public void onItemClick(AdapterView<?> arg0, View view,
							int position, long id) {

						if (answers.get(position).getNextQId() > 0) {
							Toast.makeText(getApplicationContext(),
									((TextView) view).getText(),
									Toast.LENGTH_SHORT).show();
							SessionHistory.currQID = answers.get(position)
									.getNextQId();

						} else {
							Toast.makeText(getApplicationContext(),
									"Next Scene", Toast.LENGTH_SHORT).show();
							SessionHistory.currSessionID = scene
									.getNextScenarioId();
							SessionHistory.currQID = scene.getFirstQId();
						}
						updateQA();
					}
				});
	}

	private void updateQA() {
		listAdapter.clear();
		getmDbHandler().getAllAnswer(answers, SessionHistory.currQID);
		for (ListIterator<Answer> iter = answers.listIterator(); iter.hasNext();) {
			Answer ans = iter.next();
			listAdapter.add(ans.getADes());
		}
		questions = getmDbHandler().getCurrentQuestion();
		questionTextView.setText(questions.getQDes());
		scene = getmDbHandler().getScenario();
	}

	public DatabaseHandler getmDbHandler() {
		return mDbHandler;
	}

	public void setmDbHandler(DatabaseHandler mDbHandler) {
		this.mDbHandler = mDbHandler;
	}
}