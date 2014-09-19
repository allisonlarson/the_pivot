//=require jquery
//=require jquery.turbolinks
//=require jquery_ujs
//=require bootstrap
//=require_tree .

$(document).ready(function() {

  $(".cart-btn").bind('click', false);

  $(".qty-box").focus(function() {

    var nextCartButton = $(this).closest('td').next().find('.cart-btn');
    var allCartButton = $(this).closest("div.align-to-sidebar").find(".cart-btn");

    allCartButton.removeClass('btn-default');
    nextCartButton.addClass('btn-default');

    allCartButton.bind('click', false)
    nextCartButton.unbind('click', false);

    $('.qty-box').val('')
  })

  $(".cart-link").click(function(){
    var nextCartInfo = $(this).closest('tr').next().next();
    var allCartInfo = $(this).closest("div.align-to-sidebar").find(".cart-info");


    if (nextCartInfo.hasClass('hidden')) {
      allCartInfo.addClass('hidden');
      nextCartInfo.toggleClass('hidden');
    } else {
      allCartInfo.addClass('hidden');
    }
  });

  $(".details-link").click(function(){
    $(this).closest("tr").next().toggleClass('hidden');
  })

  $(".edit-link").click(function() {
    $(this).closest('div.edit-page').find('.edit-dropdown').toggleClass('hidden');
  })

  $(".edit-address-link").click(function() {
    var nextAddressInfo = $(this).closest('tr').next();
    var allAddressInfo = $(this).closest("div.edit-page").find(".edit-address-dropdown");

    if (!$(this).closest('div.edit-page').find('.edit-dropdown').hasClass('hidden')) {
      $(this).closest('div.edit-page').find('.edit-dropdown').addClass('hidden');
    }

    if (nextAddressInfo.hasClass('hidden')) {
      allAddressInfo.addClass('hidden');
      nextAddressInfo.toggleClass('hidden');
    } else {
      allAddressInfo.addClass('hidden');
    }

  })
});

//=require turbolinks
