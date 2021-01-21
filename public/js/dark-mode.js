//Quelle: https://github.com/coliff/dark-mode-switch
//Lizenz: MIT

(function () {
    var darkSwitch = document.getElementById("darkSwitch");
    if (darkSwitch) {
        initTheme();
        darkSwitch.addEventListener("change", function (event) {
            resetTheme();
        });

        function initTheme() {
            var darkThemeSelected =
                localStorage.getItem("darkSwitch") !== null &&
                localStorage.getItem("darkSwitch") === "dark";
            darkSwitch.checked = darkThemeSelected;
            darkThemeSelected
                ? document.body.setAttribute("data-theme", "dark")
                : document.body.removeAttribute("data-theme");
        }

        function resetTheme() {
            if (darkSwitch.checked) {
                document.body.setAttribute("data-theme", "dark");
                localStorage.setItem("darkSwitch", "dark");
            } else {
                document.body.removeAttribute("data-theme");
                localStorage.removeItem("darkSwitch");
            }
        }
    }
})();
!function () {
    var t, e = document.getElementById("darkSwitch");
    if (e) {
        t = null !== localStorage.getItem("darkSwitch") && "dark" === localStorage.getItem("darkSwitch"), (e.checked = t) ? document.body.setAttribute("data-theme", "dark") : document.body.removeAttribute("data-theme"), e.addEventListener("change", function (t) {
            e.checked ? (document.body.setAttribute("data-theme", "dark"), localStorage.setItem("darkSwitch", "dark")) : (document.body.removeAttribute("data-theme"), localStorage.removeItem("darkSwitch"))
        })
    }
}();
