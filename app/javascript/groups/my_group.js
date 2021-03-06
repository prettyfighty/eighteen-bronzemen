import Rails from "@rails/ujs"
import Swal from 'sweetalert2'

// 驗證表單 必填
function validateInputPresence (e) {
  let fErrorSpan = document.createElement('SPAN')
  fErrorSpan.classList.add('error')
  fErrorSpan.textContent = '必填'
  if (e.target.value == '' && e.target.classList.toString().indexOf('border-red-400') == -1){
    e.target.classList.add('border-red-400')
    e.target.parentElement.appendChild(fErrorSpan)
  } else if (e.target.value != '' && e.target.classList.contains('border-red-400')) {
    e.target.classList.remove('border-red-400')
    e.target.parentElement.removeChild(e.target.parentElement.lastElementChild)
  }
}

// 驗證表單 Email 格式
function validateInputEmail (e) {
  let emailReg = new RegExp(/(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/)
  let fEmailErrorSpan = document.createElement('SPAN')
  fEmailErrorSpan.classList.add('error')
  fEmailErrorSpan.textContent = '請輸入正確的Email格式'
  if (emailReg.test(e.target.value) == false && e.target.classList.toString().indexOf('border-red-400') == -1){
    e.target.classList.add('border-red-400')
    e.target.parentElement.appendChild(fEmailErrorSpan)
  } else if (emailReg.test(e.target.value) == true && e.target.classList.contains('border-red-400')){
    e.target.classList.remove('border-red-400')
    e.target.parentElement.removeChild(e.target.parentElement.lastElementChild)
  }
}

document.addEventListener("turbolinks:load", function(){

  let closeReminderBtn = document.querySelector('#closeReminderBtn')
  let inviteUserBtn = document.querySelectorAll('#inviteUserBtn')
  let inviteGroupContent = document.querySelectorAll('.invite-group-content')
  let closeInviteUserBtn = document.querySelectorAll('#closeInviteUserBtn')
  let confirmInviteUser = document.querySelectorAll('#confirmInviteUser')
  let inviteUserEmail = document.querySelectorAll('#inviteUserEmail')
  let copyCode = document.querySelectorAll('#copyCode')



  // 複製群組編碼
  if (copyCode) {
    for (let i = 0; i < copyCode.length; i++) {
      copyCode[i].addEventListener("click", function(e){
        let newSpan = document.createElement("textarea")
        newSpan.value = e.target.textContent
        document.body.appendChild(newSpan)
        newSpan.select()
        document.execCommand('Copy')
        newSpan.remove()
        
        Swal.fire({
          icon: 'success',
          title: '已複製！',
          showConfirmButton: false,
          timer: 1000
        })
      })
    }
  }

  // 輸入email簡易判斷
  if (inviteUserEmail) {
    for (let i = 0; i < inviteUserEmail.length; i++) {
      inviteUserEmail[i].addEventListener('blur', function(e){
        validateInputPresence(e)
        validateInputEmail(e)
      })
    }
  }

  // 邀請其他使用者加入群組
  if (confirmInviteUser) {
    for (let i = 0; i < confirmInviteUser.length; i++) {
      confirmInviteUser[i].addEventListener("click", function(e){
        let groupId = e.target.dataset.groupId
        let inputEmail = document.querySelector('#inviteUserEmail').value
        if (inputEmail != '') {
          Rails.ajax({
            url: `/groups/${groupId}/invite_user`,
            type: 'post',
            data: `email=${inputEmail}`,
            success: function(res){
              switch (res.status) {
                case "invited":
                  Swal.fire({
                    icon: 'success',
                    title: `${res.message}`,
                  })
                  break;
                case "already":
                  Swal.fire({
                    icon: 'warning',
                    title: `${res.message}`,
                  })
                  break;
                case "not_found":
                  Swal.fire({
                    icon: 'error',
                    title: `${res.message}`,
                  })
                  break;
              }
              document.querySelector('#inviteUserEmail').value = ''
            },
            failure: function(res){
              console.log(res)
            }
          })
        }
      })
    }
  }

  // 開啟分享燈箱
  if (inviteUserBtn) {
    for (let i = 0; i < inviteUserBtn.length; i++) {
      inviteUserBtn[i].addEventListener("click", function(e){
        inviteGroupContent[i].style.display = "flex"
      })
    }
  }

  // 關閉分享燈箱
  if (closeInviteUserBtn) {
    for (let i = 0; i < closeInviteUserBtn.length; i++) {
      closeInviteUserBtn[i].addEventListener("click", function(){
        inviteGroupContent[i].style.display = "none"
      })
    }
  }

  // 關閉任務提醒燈箱
  if (closeReminderBtn) {
    closeReminderBtn.addEventListener("click", function(){
      document.querySelector(".full-screen-bg").style.display = "none"
    })
  }

})
