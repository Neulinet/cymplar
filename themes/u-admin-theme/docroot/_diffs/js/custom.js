jQuery(document).ready(function(){
	scrollToTop();  
    var loginButtons = $('div[id*="login-buttons"]');
    var loginForm = $('form[id*="fm"].sign-in-form');

    // Reveal login form
    $('a[id*="login-btn-email"]').click(function() {
        loginButtons.slideUp(600);
        loginForm.slideDown(450);
    });

    // Hide login form
    $('.login-back').click(function() {
        loginForm.slideUp(450);
        loginButtons.slideDown(600);
    });

     var toptFixedHeaderTop = $('div[id*="topt-fixed-header-top input"]');
    // Change header to fixed top
    toptFixedHeaderTop.change(function() {
        if($(this).is(":checked")) {
            toptFixedHeaderBottom.prop('checked', false);
            header.removeClass('navbar-fixed-bottom').addClass('navbar-fixed-top');
            pageCon.removeClass('header-fixed-bottom').addClass('header-fixed-top');
        } else {
            header.removeClass('navbar-fixed-top');
            pageCon.removeClass('header-fixed-top');
        }
    });
    $('[data-toggle="tooltip"]').tooltip();
});

function scrollToTop() {        
    var link = $('#to-top');
    $(window).scroll(function(){            
        if ($(this).scrollTop() > 150) {
            link.fadeIn(150);
        } else {
            link.fadeOut(150);
        }
    }); 
           
    link.click(function(){
        $("html, body").animate({ scrollTop: 0 }, 300);
        return false;
    });

};




