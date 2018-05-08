
var currentScenario = 1;
var answers = [];
var questions = [];


// 1 - School
// 2 - exists but not implemented
// 5 - Home
// 6 - Hospital
// 7 - Library

function init() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'mainDatabase.sqlite', true);
    xhr.responseType = 'arraybuffer';

    xhr.onload = function (e) {
        let uInt8Array = new Uint8Array(this.response);
        let db = new SQL.Database(uInt8Array);
        let a = db.exec("SELECT * FROM Answer");
        let q = db.exec("SELECT * FROM Question");

        for (let i in a[0].values) {
            let currentRecord = a[0].values[i];
            let record = {
                "AnswerID": currentRecord[0],
                "QuestionID": currentRecord[1],
                "ADescription": currentRecord[2],
                "NextQID": currentRecord[3],
                "Points": currentRecord[4],
            }
            answers.push(record);
        }

        for (let i in q[0].values) {
            let currentRecord = q[0].values[i];
            let record = {
                "QuestionID": currentRecord[0],
                "ScenarioID": currentRecord[1],
                "QDescription": currentRecord[2]
            }
            questions.push(record);
        }

        load();

        let loader = document.getElementById("loader");
        loader.classList.toggle('hide');
    };
    xhr.send();
}

function parse(currentScenario) {

    // main storage for parsing
    let data = [];
    let linkData = [];
    let model = [];

    // local storage for loops
    let currentQuestions = [];
    let currentQIDs = [];
    let currentAnswers = [];

    // Retrieve questions for the current scenario - compare currentScenario with the record.ScenarioID
    // Store the question IDs to use when searching for the answers
    for (let i in questions) {
        let record = questions[i];
        if (record.ScenarioID == currentScenario) {
            currentQuestions.push(record);
            currentQIDs.push(record.QuestionID);
        }
    }

    // Retrieve answers for the current scenario - compare currentQIDs with record.QuestionID
    for (let i in answers) {
        let record = answers[i];
        for (let j in currentQIDs) {
            if (record.QuestionID == currentQIDs[j]) {
                currentAnswers.push(record);
            }
        }
    }

    // Format records for answers
    for (let i in currentAnswers) {
        let currentRecord = currentAnswers[i];

        // answer purple = #5f27cd
        // terminal answer light red = #ff6b6b
        // minigame answer light orange = #feca57
        let key = "A " + currentRecord.AnswerID;
        let color = (currentRecord.NextQID == "$") ? "#ff6b6b" : (currentRecord.NextQID < 0) ? "#feca57" : "#5f27cd";
        let textField = { name: "ADescription", info: currentRecord.ADescription };
        let qIDField = { name: "QuestionID", info: currentRecord.QuestionID };
        let nextIDField = { name: "NextQID", info: currentRecord.NextQID };
        let pointsField = { name: "Points", info: currentRecord.Points };

        let record = {
            key: key,
            color: color,
            fields: [textField, qIDField, nextIDField, pointsField]
        }

        data.push(record);
    }

    // Format records for questions
    for (let i in currentQuestions) {
        let currentRecord = currentQuestions[i];

        // starting question light green = #1dd1a1
        // question light blue = #00d2d3
        let key = "Q " + currentRecord.QuestionID;
        let color = (i == 0) ? "#1dd1a1" : "#00d2d3";
        let textField = { name: "QDescription", info: currentRecord.QDescription };

        let record = {
            key: key,
            color: color,
            fields: [textField]
        }

        data.push(record);
    }

    // Format link data
    for (let i in currentAnswers) {
        let currentRecord = currentAnswers[i];

        let qLink = { from: "Q " + currentRecord.QuestionID, to: "A " + currentRecord.AnswerID, color: "#00d2d3" };
        let aLink = { from: "A " + currentRecord.AnswerID, to: "Q " + currentRecord.NextQID, color: "#341f97" };

        linkData.push(qLink);
        linkData.push(aLink);
    }

    model = { data: data, linkData: linkData }
    return model;
}

function handleSelect(select) {
    diagram.div = null;
    currentScenario = select.value;
    load();
}