// To parse this JSON data, do
//
//     final testForm = testFormFromJson(jsonString);

import 'dart:convert';

TestForm testFormFromJson(String str) => TestForm.fromJson(json.decode(str));

String testFormToJson(TestForm data) => json.encode(data.toJson());

class TestForm {
    TestForm({
        this.mockTestId,
        this.attemptType,
        this.questions,
    });

    int mockTestId;
    int attemptType;
    List<Question> questions;

    factory TestForm.fromJson(Map<String, dynamic> json) => TestForm(
        mockTestId: json["mock_test_id"],
        attemptType: json["attempt_type"],
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "mock_test_id": mockTestId,
        "attempt_type": attemptType,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    };
}

class Question {
    Question({
        this.question,
        this.answer,
        this.correct,
        this.category,
    });

    int question;
    int answer;
    int correct;
    int category;

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        answer: json["answer"],
        correct: json["correct"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "correct": correct,
        "category": category,
    };
}