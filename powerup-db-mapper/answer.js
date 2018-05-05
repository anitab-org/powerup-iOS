const answers = [
    {
        "ADescription": "Maybe another time.",
        "AnswerID": "1",
        "NextQID": "3",
        "Points": "2",
        "QuestionID": "1"
    },
    {
        "ADescription": "Sure",
        "AnswerID": "2",
        "NextQID": "2",
        "Points": "1",
        "QuestionID": "1"
    },
    {
        "ADescription": "Can we talk about this?",
        "AnswerID": "3",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "2"
    },
    {
        "ADescription": "Sure",
        "AnswerID": "4",
        "NextQID": "4",
        "Points": "1",
        "QuestionID": "2"
    },
    {
        "ADescription": "Do you have condoms?",
        "AnswerID": "5",
        "NextQID": "5",
        "Points": "3",
        "QuestionID": "4"
    },
    {
        "ADescription": "Let’s head inside",
        "AnswerID": "6",
        "NextQID": "$",
        "Points": "0",
        "QuestionID": "4"
    },
    {
        "ADescription": "I’m feeling weird. Can we talk about this?",
        "AnswerID": "7",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "4"
    },
    {
        "ADescription": "Let’s go to the store and buy some.",
        "AnswerID": "8",
        "NextQID": "6",
        "Points": "4",
        "QuestionID": "5"
    },
    {
        "ADescription": "I am not feeling comfortable about this.",
        "AnswerID": "9",
        "NextQID": "7",
        "Points": "4",
        "QuestionID": "5"
    },
    {
        "ADescription": "Nevermind let’s just have sex.",
        "AnswerID": "10",
        "NextQID": "-1",
        "Points": "0",
        "QuestionID": "5"
    },
    {
        "ADescription": "I really think we should find a condom",
        "AnswerID": "11",
        "NextQID": "6",
        "Points": "3",
        "QuestionID": "7"
    },
    {
        "ADescription": "I changed my mind. I wanna go home.",
        "AnswerID": "12",
        "NextQID": "$",
        "Points": "3",
        "QuestionID": "7"
    },
    {
        "ADescription": "Ok I am going home",
        "AnswerID": "13",
        "NextQID": "$",
        "Points": "4",
        "QuestionID": "6"
    },
    {
        "ADescription": "Ok fine. Let’s have sex",
        "AnswerID": "14",
        "NextQID": "-1",
        "Points": "0",
        "QuestionID": "6"
    },
    {
        "ADescription": "Returns Home",
        "AnswerID": "15",
        "NextQID": "$",
        "Points": "0",
        "QuestionID": "3"
    },
    {
        "ADescription": "Maybe another time.",
        "AnswerID": "16",
        "NextQID": "3",
        "Points": "2",
        "QuestionID": "8"
    },
    {
        "ADescription": "Sure",
        "AnswerID": "17",
        "NextQID": "2",
        "Points": "1",
        "QuestionID": "8"
    },
    {
        "ADescription": "Can we talk about this?",
        "AnswerID": "18",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "9"
    },
    {
        "ADescription": "Sure",
        "AnswerID": "19",
        "NextQID": "4",
        "Points": "1",
        "QuestionID": "9"
    },
    {
        "ADescription": "Do you have condoms?",
        "AnswerID": "20",
        "NextQID": "5",
        "Points": "3",
        "QuestionID": "11"
    },
    {
        "ADescription": "Let’s head inside",
        "AnswerID": "21",
        "NextQID": "$",
        "Points": "0",
        "QuestionID": "11"
    },
    {
        "ADescription": "I’m feeling weird. Can we talk about this?",
        "AnswerID": "22",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "11"
    },
    {
        "ADescription": "Let’s go to the store and buy some.",
        "AnswerID": "23",
        "NextQID": "6",
        "Points": "4",
        "QuestionID": "12"
    },
    {
        "ADescription": "I am not feeling comfortable about this.",
        "AnswerID": "24",
        "NextQID": "7",
        "Points": "4",
        "QuestionID": "12"
    },
    {
        "ADescription": "Nevermind let’s just have sex.",
        "AnswerID": "25",
        "NextQID": "-1",
        "Points": "0",
        "QuestionID": "12"
    },
    {
        "ADescription": "I really think we should find a condom",
        "AnswerID": "26",
        "NextQID": "6",
        "Points": "3",
        "QuestionID": "14"
    },
    {
        "ADescription": "I changed my mind. I wanna go home.",
        "AnswerID": "27",
        "NextQID": "$",
        "Points": "3",
        "QuestionID": "14"
    },
    {
        "ADescription": "Ok I am going home",
        "AnswerID": "28",
        "NextQID": "$",
        "Points": "4",
        "QuestionID": "13"
    },
    {
        "ADescription": "Ok fine. Let’s have sex",
        "AnswerID": "29",
        "NextQID": "-1",
        "Points": "0",
        "QuestionID": "13"
    },
    {
        "ADescription": "Returns Home",
        "AnswerID": "30",
        "NextQID": "$",
        "Points": "0",
        "QuestionID": "10"
    },
    {
        "ADescription": "Maybe another time.",
        "AnswerID": "31",
        "NextQID": "3",
        "Points": "2",
        "QuestionID": "15"
    },
    {
        "ADescription": "Sure",
        "AnswerID": "32",
        "NextQID": "2",
        "Points": "1",
        "QuestionID": "15"
    },
    {
        "ADescription": "Can we talk about this?",
        "AnswerID": "33",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "16"
    },
    {
        "ADescription": "Sure",
        "AnswerID": "34",
        "NextQID": "4",
        "Points": "1",
        "QuestionID": "16"
    },
    {
        "ADescription": "Do you have condoms?",
        "AnswerID": "35",
        "NextQID": "5",
        "Points": "3",
        "QuestionID": "18"
    },
    {
        "ADescription": "Let’s head inside",
        "AnswerID": "36",
        "NextQID": "$",
        "Points": "0",
        "QuestionID": "18"
    },
    {
        "ADescription": "I’m feeling weird. Can we talk about this?",
        "AnswerID": "37",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "18"
    },
    {
        "ADescription": "Let’s go to the store and buy some.",
        "AnswerID": "38",
        "NextQID": "6",
        "Points": "4",
        "QuestionID": "19"
    },
    {
        "ADescription": "I am not feeling comfortable about this.",
        "AnswerID": "39",
        "NextQID": "7",
        "Points": "4",
        "QuestionID": "19"
    },
    {
        "ADescription": "Nevermind let’s just have sex.",
        "AnswerID": "40",
        "NextQID": "-1",
        "Points": "0",
        "QuestionID": "19"
    },
    {
        "ADescription": "I really think we should find a condom",
        "AnswerID": "41",
        "NextQID": "6",
        "Points": "3",
        "QuestionID": "21"
    },
    {
        "ADescription": "I changed my mind. I wanna go home.",
        "AnswerID": "42",
        "NextQID": "$",
        "Points": "3",
        "QuestionID": "21"
    },
    {
        "ADescription": "Ok I am going home",
        "AnswerID": "43",
        "NextQID": "$",
        "Points": "4",
        "QuestionID": "20"
    },
    {
        "ADescription": "Ok fine. Let’s have sex",
        "AnswerID": "44",
        "NextQID": "-1",
        "Points": "0",
        "QuestionID": "20"
    },
    {
        "ADescription": "Returns Home",
        "AnswerID": "45",
        "NextQID": "$",
        "Points": "0",
        "QuestionID": "17"
    },
    {
        "ADescription": "Friend X you never returned my ipod from last summer...",
        "AnswerID": "46",
        "NextQID": "30",
        "Points": "1",
        "QuestionID": "29"
    },
    {
        "ADescription": "Fine whatever. Here it is.",
        "AnswerID": "47",
        "NextQID": "31",
        "Points": "2",
        "QuestionID": "30"
    },
    {
        "ADescription": "I don't know man. I begged my mom for this last Christmas. This is my baby.",
        "AnswerID": "48",
        "NextQID": "32",
        "Points": "3",
        "QuestionID": "30"
    },
    {
        "ADescription": "ABSOLUTELY not. You are a terrible person and I never want to see you again.",
        "AnswerID": "49",
        "NextQID": "33",
        "Points": "1",
        "QuestionID": "30"
    },
    {
        "ADescription": "Uh... okay. I guess.",
        "AnswerID": "50",
        "NextQID": "31",
        "Points": "2",
        "QuestionID": "32"
    },
    {
        "ADescription": "I just can't do it. I'm sorry. I'd love to help with anything else.",
        "AnswerID": "51",
        "NextQID": "34",
        "Points": "1",
        "QuestionID": "32"
    },
    {
        "ADescription": "Never. I would never trust anyone like you.",
        "AnswerID": "52",
        "NextQID": "33",
        "Points": "0",
        "QuestionID": "32"
    },
    {
        "ADescription": "Whatever!",
        "AnswerID": "53",
        "NextQID": "$",
        "Points": "1",
        "QuestionID": "33"
    },
    {
        "ADescription": "Yo! See you soon",
        "AnswerID": "54",
        "NextQID": "$",
        "Points": "1",
        "QuestionID": "34"
    },
    {
        "ADescription": "Hehe.. be careful",
        "AnswerID": "55",
        "NextQID": "$",
        "Points": "1",
        "QuestionID": "31"
    },
    {
        "ADescription": "Yes..I am comfortable and prefer speaking alone",
        "AnswerID": "56",
        "NextQID": "36",
        "Points": "2",
        "QuestionID": "35"
    },
    {
        "ADescription": "No..I am not comfortable. Please call her.",
        "AnswerID": "57",
        "NextQID": "40",
        "Points": "2",
        "QuestionID": "35"
    },
    {
        "ADescription": "Say yes even if you are not comfortable",
        "AnswerID": "58",
        "NextQID": "36",
        "Points": "2",
        "QuestionID": "35"
    },
    {
        "ADescription": "Answer questions hesitantly",
        "AnswerID": "59",
        "NextQID": "38",
        "Points": "2",
        "QuestionID": "36"
    },
    {
        "ADescription": "Please call my mother",
        "AnswerID": "60",
        "NextQID": "40",
        "Points": "2",
        "QuestionID": "36"
    },
    {
        "ADescription": "Stay quiet until doctor calls your mother",
        "AnswerID": "61",
        "NextQID": "40",
        "Points": "2",
        "QuestionID": "36"
    },
    {
        "ADescription": "Stay quiet and let your mother answer for you",
        "AnswerID": "62",
        "NextQID": "37",
        "Points": "2",
        "QuestionID": "40"
    },
    {
        "ADescription": "Voluntarily answer questions yourself",
        "AnswerID": "63",
        "NextQID": "38",
        "Points": "2",
        "QuestionID": "40"
    },
    {
        "ADescription": "Give answers in detail",
        "AnswerID": "64",
        "NextQID": "38",
        "Points": "2",
        "QuestionID": "40"
    },
    {
        "ADescription": "Stay quiet",
        "AnswerID": "65",
        "NextQID": "38",
        "Points": "2",
        "QuestionID": "37"
    },
    {
        "ADescription": "Correct her and tell all problems clearly in detail",
        "AnswerID": "66",
        "NextQID": "38",
        "Points": "2",
        "QuestionID": "37"
    },
    {
        "ADescription": "Tell doctor about any pain or infection or health problem during checkup",
        "AnswerID": "67",
        "NextQID": "39",
        "Points": "2",
        "QuestionID": "38"
    },
    {
        "ADescription": "Stay quiet. Don't tell any problem you are facing to save embarrassment",
        "AnswerID": "68",
        "NextQID": "39",
        "Points": "2",
        "QuestionID": "38"
    },
    {
        "ADescription": "Lie on checkup questions to save embarrassment",
        "AnswerID": "69",
        "NextQID": "39",
        "Points": "2",
        "QuestionID": "38"
    },
    {
        "ADescription": "No..Return home",
        "AnswerID": "70",
        "NextQID": "-3",
        "Points": "2",
        "QuestionID": "39"
    },
    {
        "ADescription": "No..Ask your mother later after returning home",
        "AnswerID": "71",
        "NextQID": "-3",
        "Points": "2",
        "QuestionID": "39"
    },
    {
        "ADescription": "Ask your all doubts related to puberty",
        "AnswerID": "72",
        "NextQID": "-3",
        "Points": "2",
        "QuestionID": "39"
    },
    {
        "ADescription": "I am getting acnes and fat at hips",
        "AnswerID": "73",
        "NextQID": "42",
        "Points": "2",
        "QuestionID": "41"
    },
    {
        "ADescription": "I am not growing.Everybody else has got much bigger than me",
        "AnswerID": "74",
        "NextQID": "43",
        "Points": "2",
        "QuestionID": "41"
    },
    {
        "ADescription": "I have got period for the first time",
        "AnswerID": "75",
        "NextQID": "44",
        "Points": "2",
        "QuestionID": "41"
    },
    {
        "ADescription": "I should go diet",
        "AnswerID": "76",
        "NextQID": "45",
        "Points": "2",
        "QuestionID": "42"
    },
    {
        "ADescription": "I should talk to Mom",
        "AnswerID": "77",
        "NextQID": "46",
        "Points": "2",
        "QuestionID": "42"
    },
    {
        "ADescription": "I should search on Internet",
        "AnswerID": "78",
        "NextQID": "47",
        "Points": "2",
        "QuestionID": "42"
    },
    {
        "ADescription": "Lemme ask my friends",
        "AnswerID": "79",
        "NextQID": "48",
        "Points": "2",
        "QuestionID": "42"
    },
    {
        "ADescription": "Let me eat more over my capacity",
        "AnswerID": "80",
        "NextQID": "45",
        "Points": "2",
        "QuestionID": "43"
    },
    {
        "ADescription": "I should talk to mom",
        "AnswerID": "81",
        "NextQID": "46",
        "Points": "2",
        "QuestionID": "43"
    },
    {
        "ADescription": "Go to Internet",
        "AnswerID": "82",
        "NextQID": "47",
        "Points": "2",
        "QuestionID": "43"
    },
    {
        "ADescription": "I should wait !! I will get better",
        "AnswerID": "83",
        "NextQID": "45",
        "Points": "2",
        "QuestionID": "44"
    },
    {
        "ADescription": "I should talk to Mom",
        "AnswerID": "84",
        "NextQID": "46",
        "Points": "2",
        "QuestionID": "44"
    },
    {
        "ADescription": "Visit Doctor !!",
        "AnswerID": "85",
        "NextQID": "-2",
        "Points": "2",
        "QuestionID": "45"
    },
    {
        "ADescription": "Go to Mom",
        "AnswerID": "86",
        "NextQID": "46",
        "Points": "2",
        "QuestionID": "45"
    },
    {
        "ADescription": "Visit Doctor!!",
        "AnswerID": "87",
        "NextQID": "-2",
        "Points": "2",
        "QuestionID": "46"
    },
    {
        "ADescription": "Take medicine",
        "AnswerID": "88",
        "NextQID": "45",
        "Points": "2",
        "QuestionID": "47"
    },
    {
        "ADescription": "Go to Mom",
        "AnswerID": "89",
        "NextQID": "46",
        "Points": "2",
        "QuestionID": "47"
    },
    {
        "ADescription": "Visit Doctor!!",
        "AnswerID": "90",
        "NextQID": "-2",
        "Points": "2",
        "QuestionID": "47"
    },
    {
        "ADescription": "Aaruhi- Talk to your Mom",
        "AnswerID": "91",
        "NextQID": "46",
        "Points": "2",
        "QuestionID": "48"
    },
    {
        "ADescription": "Juhi- It's happening to me as well..Go to Internet",
        "AnswerID": "92",
        "NextQID": "47",
        "Points": "2",
        "QuestionID": "48"
    },
    {
        "ADescription": "Ruhi- It's not happening to me..Talk to your Mom",
        "AnswerID": "93",
        "NextQID": "46",
        "Points": "2",
        "QuestionID": "48"
    },
    {
        "ADescription": "It's fine since Mathew is my uncle",
        "AnswerID": "94",
        "NextQID": "50",
        "Points": "2",
        "QuestionID": "49"
    },
    {
        "ADescription": "This looks wrong and I will be careful",
        "AnswerID": "95",
        "NextQID": "51",
        "Points": "2",
        "QuestionID": "49"
    },
    {
        "ADescription": "It is unexpected for you. You couldn't do anything as you are in shock.",
        "AnswerID": "96",
        "NextQID": "52",
        "Points": "2",
        "QuestionID": "50"
    },
    {
        "ADescription": "Shout until someone comes. Tell everybody about this.",
        "AnswerID": "97",
        "NextQID": "54",
        "Points": "2",
        "QuestionID": "51"
    },
    {
        "ADescription": "Hit him with anything nearby and run as fast as you can. Tell everyone about this",
        "AnswerID": "98",
        "NextQID": "54",
        "Points": "2",
        "QuestionID": "51"
    },
    {
        "ADescription": "You expected this and were prepared. Call someone secretly with your phone.",
        "AnswerID": "99",
        "NextQID": "54",
        "Points": "2",
        "QuestionID": "51"
    },
    {
        "ADescription": "Tell your parents about this",
        "AnswerID": "100",
        "NextQID": "54",
        "Points": "2",
        "QuestionID": "52"
    },
    {
        "ADescription": "Tell your friends about this",
        "AnswerID": "101",
        "NextQID": "55",
        "Points": "2",
        "QuestionID": "52"
    },
    {
        "ADescription": "Remain Quiet.",
        "AnswerID": "102",
        "NextQID": "53",
        "Points": "2",
        "QuestionID": "52"
    },
    {
        "ADescription": "Tell your parents about this",
        "AnswerID": "103",
        "NextQID": "54",
        "Points": "2",
        "QuestionID": "53"
    },
    {
        "ADescription": "Tell your friends about this",
        "AnswerID": "104",
        "NextQID": "55",
        "Points": "2",
        "QuestionID": "53"
    },
    {
        "ADescription": "Remain Quiet.",
        "AnswerID": "105",
        "NextQID": "53",
        "Points": "2",
        "QuestionID": "53"
    },
    {
        "ADescription": "Mathew is handed over to the police",
        "AnswerID": "106",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "54"
    },
    {
        "ADescription": "Stay Quiet and keep suffering.",
        "AnswerID": "107",
        "NextQID": "$",
        "Points": "2",
        "QuestionID": "56"
    },
    {
        "ADescription": "Tell your parents",
        "AnswerID": "108",
        "NextQID": "54",
        "Points": "2",
        "QuestionID": "56"
    },
    {
        "ADescription": "Neha: Tell your parents",
        "AnswerID": "109",
        "NextQID": "54",
        "Points": "2",
        "QuestionID": "55"
    },
    {
        "ADescription": "Sneha: Stay quiet..he is your uncle",
        "AnswerID": "110",
        "NextQID": "56",
        "Points": "2",
        "QuestionID": "55"
    }
]
