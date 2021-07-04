import Rails from "@rails/ujs"
import Swal from 'sweetalert2'


document.addEventListener("turbolinks:load", function(){

  let closeReminderBtn = document.querySelector('#closeReminderBtn')
  let shareMissionBtn = document.querySelectorAll('#shareMissionBtn')
  let shareMissionContent = document.querySelectorAll('.share-mission-content')
  let closeShareMissionBtn = document.querySelectorAll('#closeShareMissionBtn')
  let confirmSharedUser = document.querySelectorAll('#confirmSharedUser')
  let sharedUserEmail = document.querySelectorAll('#sharedUserEmail')

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

  // 輸入email簡易判斷
  if (sharedUserEmail) {
    for (let i = 0; i < sharedUserEmail.length; i++) {
      sharedUserEmail[i].addEventListener('blur', function(e){
        validateInputPresence(e)
        validateInputEmail(e)
      })
    }
  }

  // 分享任務給其他使用者
  if (confirmSharedUser) {
    for (let i = 0; i < confirmSharedUser.length; i++) {
      confirmSharedUser[i].addEventListener("click", function(e){
        let missionId = e.target.dataset.missionId
        let inputEmail = e.target.previousElementSibling.value
        if (inputEmail != '') {
          Rails.ajax({
            url: `/missions/${missionId}/share_mission`,
            type: 'post',
            data: `email=${inputEmail}`,
            success: function(res){
              switch (res.status) {
                case "shared":
                  Swal.fire({
                    icon: 'success',
                    title: `${res.message}`,
                  })
                  break;
                case "delete":
                  Swal.fire({
                    icon: 'success',
                    title: `${res.message}`,
                  })
                  break;
                case "self":
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
              e.target.previousElementSibling.value = ''
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
  if (shareMissionBtn) {
    for (let i = 0; i < shareMissionBtn.length; i++) {
      shareMissionBtn[i].addEventListener("click", function(e){
        shareMissionContent[i].style.display = "flex"
      })
    }
  }

  // 關閉分享燈箱
  if (closeShareMissionBtn) {
    for (let i = 0; i < closeShareMissionBtn.length; i++) {
      closeShareMissionBtn[i].addEventListener("click", function(){
        shareMissionContent[i].style.display = "none"
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
