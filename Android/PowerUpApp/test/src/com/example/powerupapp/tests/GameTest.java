package com.example.powerupapp.tests;

import java.util.List;

import com.example.powerupapp.Game;
import com.example.powerupapp.R;
import com.example.powerupapp.datamodel.Answer;
import com.example.powerupapp.datamodel.Question;
import com.example.powerupapp.datamodel.Scenario;
import com.example.powerupapp.datamodel.SessionHistory;
import com.example.powerupapp.db.DatabaseHandler;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.test.ActivityInstrumentationTestCase2;
import android.test.TouchUtils;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

public class GameTest extends ActivityInstrumentationTestCase2<Game> {

	private Game mGameTestActivity;
	private List<Answer> answers;
	private Question questions;
	private Scenario scene;
	private ListView mainListView;
	private TextView questionTextView;
	private TextView scenarioNameTextView;
	private TextView pointsTextView;
	private Button replay;
	private Button goToMap;

	public GameTest() {
		super(Game.class);
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void setUp() throws Exception {
		super.setUp();
		Intent intent = new Intent(getInstrumentation().getTargetContext(),
				Game.class);
		setActivityIntent(intent);
		setActivityInitialTouchMode(true);
		mGameTestActivity = getActivity();
		replay = (Button) mGameTestActivity.findViewById(R.id.button2);
		goToMap = (Button) mGameTestActivity.findViewById(R.id.button1);
	}

	public void testPreconditions() {
		assertNotNull("gameTestActivity is null", mGameTestActivity);
	}

	public void testQuestion_scenarioID_matchesWithCurrentScenario() {
		assertTrue(questions.getScenarioId() == scene.getId());
	}

	public void testAnswer_QuestionID_matchesWithCurrentQuestion() {
		assertTrue(answers.get(0).getQId() == questions.getQId());
	}

	public void testLoopsInScenario() {
		int[] scenarioIdArray = new int[10];
		for (int i = 0; i < scenarioIdArray.length; i++) {
			scenarioIdArray[i] = 0;
		}
		while (scene.getNextScenarioId() != -1) {
			assertTrue(scenarioIdArray[scene.getId()] == 0);
			scenarioIdArray[scene.getId()] = 1;
			SessionHistory.currSessionID = scene.getNextScenarioId();
			Intent intent = new Intent(getInstrumentation().getTargetContext(),
					Game.class);
			setActivityIntent(intent);
		}
	}

	@SuppressLint("NewApi")
	public void testReplay_clickButtonAndExpectInactiveGoToMap() {
		TouchUtils.clickView(this, replay);
		assertTrue(goToMap.getAlpha() == 0.00);
		assertTrue(replay.getAlpha() == 0.00);
		assertTrue(replay.callOnClick() == false);
		assertTrue(goToMap.callOnClick() == false);
	}

	@SuppressLint("NewApi")
	public void testGoToMap_clickButtonAndExpectInactiveReplay() {
		TouchUtils.clickView(this, goToMap);
		assertTrue(goToMap.getAlpha() == 0.00);
		assertTrue(replay.getAlpha() == 0.00);
		assertTrue(replay.callOnClick() == false);
		assertTrue(goToMap.callOnClick() == false);
	}
}
