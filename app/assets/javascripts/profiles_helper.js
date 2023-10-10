/* eslint-disable no-extra-semi */
;(function () {
  const profiles = document.querySelectorAll(".profile")

  profiles.forEach((profile) => {
    profile.addEventListener("toggle", () => {
      const iconCaret = profile.querySelector(".icon-caret")
      const drawers = profile.querySelectorAll(".drawer-profile, .drawer-open")

      if (profile.open) {
        iconCaret.classList.add("profile-open")
        drawers.forEach((drawer) => {
          drawer.classList.replace("drawer-profile", "drawer-open")
        })
      } else {
        iconCaret.classList.remove("profile-open")
        drawers.forEach((drawer) => {
          drawer.classList.replace("drawer-open", "drawer-profile")
        })
      }
    })
  })
})()
