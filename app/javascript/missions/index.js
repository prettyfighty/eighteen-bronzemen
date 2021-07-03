document.addEventListener("turbolinks:load", function(){

  let closeReminderBtn = document.querySelector('#closeReminderBtn')

  if (closeReminderBtn) {
    closeReminderBtn.addEventListener("click", () => {
      document.querySelector(".full-screen-bg").style.display = "none"
    })
  }

})
