package com.example.powerupapp;

import com.example.powerupapp.R;
import com.example.powerupapp.datamodel.Answer;
import com.example.powerupapp.datamodel.Question;
import com.example.powerupapp.datamodel.Scenario;
import com.example.powerupapp.datamodel.SessionHistory;
import com.example.powerupapp.db.DatabaseHandler;
import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

@SuppressLint("NewApi")
public class Game extends Activity {

	private DatabaseHandler mDbHandler;
	private List<Answer> answers;
	private Question questions;
	private Scenario scene;
	private ListView mainListView;
	private TextView questionTextView;
	private TextView scenarioNameTextView;
	private TextView pointsTextView;
	private Button replay;
	private Button goToMap;
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
		scenarioNameTextView = (TextView) findViewById(R.id.editText2);
		pointsTextView = (TextView) findViewById(R.id.textView1);
		listAdapter = new ArrayAdapter<String>(this, R.layout.simplerow,
				new ArrayList<String>());
		answers = new ArrayList<Answer>();
		goToMap = (Button) findViewById(R.id.button1);
		replay = (Button) findViewById(R.id.button2);
		// pointsTextView.setText(SessionHistory.totalPoints.toString());
		// Update Scene
		updateScenario();
		if (scene.getReplayed() == 1) {
			goToMap.setAlpha((float) 0.0);
			replay.setAlpha((float) 0.0);
		}

		// Set the ArrayAdapter as the ListView's adapter.
		mainListView.setAdapter(listAdapter);
		mainListView
				.setOnItemClickListener(new AdapterView.OnItemClickListener() {
					@Override
					public void onItemClick(AdapterView<?> arg0, View view,
							int position, long id) {
						if (answers.get(position).getNextQId() > 0) {
							Toast.makeText(
									getApplicationContext(),
									((TextView) view).getText()
											+ scene.getScenarioName(),
									Toast.LENGTH_SHORT).show();
							// Next Question
							SessionHistory.currQID = answers.get(position)
									.getNextQId();
							updatePoints(position);
							updateQA();

						} else {
							Toast.makeText(getApplicationContext(),
									"Next Scene", Toast.LENGTH_SHORT).show();
							SessionHistory.currSessionID = scene
									.getNextScenarioId();
							if (SessionHistory.currSessionID == -1) {
								// Check to make sure all scenes are completed
								SessionHistory.currSessionID = 1;
							}
							updatePoints(position);
							getmDbHandler().setCompletedScenario(
									scene.getScenarioName());
							SessionHistory.currScenePoints = 0;
							updateScenario();
						}
					}
				});
	}

	private void updatePoints(int position) {
		// Update the Scene Points
		SessionHistory.currScenePoints += answers.get(position).getPoint();
		// Update Total Points
		SessionHistory.totalPoints += answers.get(position).getPoint();
		// pointsTextView.setText(SessionHistory.totalPoints.toString());
	}

	private void updateScenario() {
		scene = getmDbHandler().getScenario();
		// Replay a scenario
		if (scene.getReplayed() == 0) {
			// goToMap Mechanics
			goToMap.setAlpha((float) 1.0);
			goToMap.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					// Incase the user move back to map in between a running
					// Scenario.
					SessionHistory.totalPoints -= SessionHistory.currScenePoints;
					goToMap.setClickable(false);
					Intent myIntent = new Intent(Game.this, Map.class);
					startActivityForResult(myIntent, 0);
					getmDbHandler()
							.setReplayedScenario(scene.getScenarioName());
					goToMap.setAlpha((float) 0.0);
					replay.setAlpha((float) 0.0);
				}
			});
			// Replay Mechanics
			replay.setAlpha((float) 1.0);
			replay.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					// Incase the user move back to map in between a running
					// Scenario.

					SessionHistory.totalPoints -= SessionHistory.currScenePoints;
					replay.setClickable(false);
					Intent myIntent = new Intent(Game.this, Game.class);
					startActivityForResult(myIntent, 0);
					getmDbHandler()
							.setReplayedScenario(scene.getScenarioName());
					goToMap.setAlpha((float) 0.0);
					replay.setAlpha((float) 0.0);
				}
			});
		}
		
		// If completed check if it is last scene
		if (scene.getCompleted() == 1) {
			if (scene.getNextScenarioId() == -1) {
				Intent myIntent = new Intent(Game.this, GameOver.class);
				startActivityForResult(myIntent, 0);
			} else {
				SessionHistory.currSessionID = scene.getNextScenarioId();
				updateScenario();
			}
		}
		SessionHistory.currQID = scene.getFirstQId();
		scenarioNameTextView.setText(scene.getScenarioName());
		updateQA();
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
	}

	public DatabaseHandler getmDbHandler() {
		return mDbHandler;
	}

	public void setmDbHandler(DatabaseHandler mDbHandler) {
		this.mDbHandler = mDbHandler;
	}
}