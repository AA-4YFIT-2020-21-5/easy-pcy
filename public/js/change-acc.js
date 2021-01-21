$("#change-btn").on("click", () => {
    //Username
    let userText = $("#username");
    let changeUser = $("#change-username");

    $("#change-username input[type=text]").val(userText.text())
    $("#change-username label").addClass("active")

    userText.css("display", "none")
    changeUser.css("display", "initial");

    //Textarea
    let descText = $("#desc");
    let changeDesc = $("#change-desc");

    $("#change-desc textarea").val(descText.text())

    descText.css("display", "none")
    changeDesc.css("display", "initial");

    //Btns
    $("#change-btn").css("display", "none")
    $("#save-btn").css("display", "initial")
    $("#cancel-btn").css("display", "initial")
})

$("#cancel-btn").on("click", () => {
    //Username
    $("#username").css("display", "initial")
    $("#change-username").css("display", "none");

    //Textarea
    $("#desc").css("display", "initial")
    $("#change-desc").css("display", "none");

    //Btns
    $("#change-btn").css("display", "initial")
    $("#save-btn").css("display", "none")
    $("#cancel-btn").css("display", "none")
})