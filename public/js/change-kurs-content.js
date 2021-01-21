$("#change-btn-kurs").on("click",() => {
    //Titel
    let titleText = $("#kurs-title");
    let changeTitle = $("#change-title");

    $("#change-title input[type=text]").val(titleText.text())
    $("#change-title label").addClass("active")

    titleText.css("display", "none")
    changeTitle.css("display", "inherit");

    //Textarea
    let contentText = $("#kurs-content");
    let changeContent = $("#change-content");

    $("#change-content textarea").val(contentText.text())

    contentText.css("display", "none")
    changeContent.css("display", "initial");

    //Btns
    $("#save-btn").css("display", "initial")
    $("#cancel-btn").css("display", "initial")
})

$("#cancel-btn").on("click", () => {
    //Username
    $("#kurs-title").css("display", "inherit")
    $("#change-title").css("display", "none");

    //Textarea
    $("#kurs-content").css("display", "inherit")
    $("#change-content").css("display", "none");

    //Btns
    $("#save-btn").css("display", "none")
    $("#cancel-btn").css("display", "none")
})