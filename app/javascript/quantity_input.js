$(document).ready(function() {
  $(document).on("click", ".js-plus", function() {
    var qtyScope = $(this).closest(".quantity-scope");
    var input = qtyScope.find(".count");
    var currentValue = parseInt(input.val());

    input.val(currentValue + 1);
    if (input.hasClass("count-update")) {
      input.trigger("change");
    }
  });

  $(document).on("click", ".js-minus", function() {
    var qtyScope = $(this).closest(".quantity-scope");
    var input = qtyScope.find(".count");
    var currentValue = parseInt(input.val());
    
    if (currentValue > 1) {
      input.val(currentValue - 1);
      if (input.hasClass("count-update")) {
        input.trigger("change");
      }
    }
  });

  $(document).on("change", ".count", function() {
    sendUpdateRequest($(this));
  });

  function sendUpdateRequest(input) {
    var form = input.closest("form");
    form.submit();
  }

  $('[data-bs-toggle="collapse"]').on("click", function() {
    var $button = $(this);

    if ($button.attr("aria-expanded") === "false") {
      $button.text("Show Details");
    } else {
      $button.text("Hide Details");
    }
  });

  $(".order-cancellation-form .order_cancellation_reason").on("input", function() {
    var cancellationReason = $(this).val().trim();
    var cancelButton = $(this).closest(".order-cancellation-form").find(".cancel-button");

    // Kiểm tra nếu lý do hủy đơn đã được cung cấp
    if (cancellationReason.length > 0) {
      cancelButton.prop("disabled", false); // Bật nút
    } else {
      cancelButton.prop("disabled", true); // Tắt nút
    }
  });
});
