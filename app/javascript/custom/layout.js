
function enableHeaderLinkDivs() {
  document.querySelectorAll('.nav-link, .user-link').forEach(div => {
    div.addEventListener('click', clickHeaderLink);
  })
}
document.addEventListener('turbo:load', () => enableHeaderLinkDivs());

function clickHeaderLink(e) {
  if(e.target.nodeName == 'A') return;
  e.target.getElementsByTagName('a')[0].click();
}
