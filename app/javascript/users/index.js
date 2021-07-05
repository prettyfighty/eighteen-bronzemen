document.addEventListener("turbolinks:load", function(){

  let userAvatarInput = document.querySelector('#user_avatar')

  if (userAvatarInput) {
    userAvatarInput.addEventListener("change", function(e){
      let userAvatarImg = document.querySelector('#userAvatar')
      userAvatarImg.src = URL.createObjectURL(e.target.files[0])
      userAvatarImg.addEventListener("load", function(){
        URL.revokeObjectURL(userAvatarImg.src)
      })
    })
  }
})
