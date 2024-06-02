let current_quiz = -1;
let score = 0;
let q_count = quiz.length;

let start = document.querySelector(".start");
let question = document.querySelector(".question");
let answers = document.querySelectorAll(".answer");
let confirm = document.querySelector(".confirm");
let next_question = document.querySelector(".next_question");
let score_box = document.querySelector(".score");

function startGame() {
    //Hide play button
    start.classList.add("d-none");
    //Show question box
    let playing_only = document.querySelectorAll(".playing-only");
    playing_only.forEach((el) => el.style.display = 'block')
    showNextQuestion();
}

function showNextQuestion() {
    //Check if there are more questions
    if (current_quiz + 1 == q_count) {
        alert("Quiz finito");
        location.reload();
    }

    //Reset state
    answers.forEach((a) => {
        a.removeAttribute("selected");
        a.classList.remove("show-solution");
        a.classList.add("d-none");
    })
    confirm.classList.remove("d-none");
    next_question.classList.add("d-none");
    //Load next question
    let quiz_data = quiz[++current_quiz];
    question.textContent = quiz_data.question;
    for (let i = 0; i < quiz_data.options.length; i++) {
        answers[i].classList.remove("d-none");
        answers[i].textContent = quiz_data.options[i];
    }
    //Scroll to top
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function selectAnswer(target) {
    target.toggleAttribute("selected");
}

function confirmAnswer() {
    let solutions = quiz[current_quiz].correct;
    let correct = true;
    for (let i = 0; i < answers.length; i++) {
        if (solutions.indexOf(i) != -1) {
            answers[i].classList.add("show-solution");
            if (!answers[i].hasAttribute("selected")) {
                correct = false;
            }
        } else {
            if (answers[i].hasAttribute("selected")) {
                correct = false;
            }
        }
    }
    if (correct) 
        updateScore();
    confirm.classList.add("d-none");
    next_question.classList.remove("d-none");
}

function updateScore() {
    score++;
    score_box.textContent = "Score: " + score;
}

function shuffleQuestions() {
    shuffle(quiz);
}

function shuffle(array) {
    let currentIndex = array.length;
  
    // While there remain elements to shuffle...
    while (currentIndex != 0) {
  
      // Pick a remaining element...
      let randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex--;
  
      // And swap it with the current element.
      [array[currentIndex], array[randomIndex]] = [
        array[randomIndex], array[currentIndex]];
    }
  }