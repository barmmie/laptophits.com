function handleAmazonProductLinkClicks(event) {
  ga('send', 'event', {
    eventCategory: 'Amazon Product Link',
    eventAction: 'click',
    eventLabel: event.target.href,
    eventValue: 1,
    transport: 'beacon'
  });
}

jQuery(document).ready(function() {  
  var baseURI = window.location.host

  $('a').click(event, function() {
    if (event.target.hostname == 'www.amazon.com') {
      handleAmazonProductLinkClicks(event);
    }
  })
})


