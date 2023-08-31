/* eslint-disable no-extra-semi */
;(function () {
  const profiles = document.querySelectorAll(".profile")

  profiles.forEach((profile) => {
    profile.addEventListener("toggle", () => {
      const iconCaret = profile.querySelector(".icon-caret")
      const drawer =
        profile.querySelector(".drawer-profile") ||
        profile.querySelector(".drawer-open")

      if (profile.open) {
        iconCaret.classList.add("profile-open")
        drawer.classList.replace("drawer-profile", "drawer-open")
      } else {
        iconCaret.classList.remove("profile-open")
        drawer.classList.replace("drawer-open", "drawer-profile")
      }
    })
  })
})()
