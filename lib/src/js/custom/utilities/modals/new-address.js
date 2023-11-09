"use strict";

// Class definition
var KTModalNewAddress = function () {
	var submitButton;
	var cancelButton;
	var validator;
	var form;
	var modal;
	var modalEl;

	// Init form inputs
	var initForm = function() {
		// Team assign. For more info, plase visit the official plugin site: https://select2.org/
        $(form.querySelector('[name="country"]')).select2().on('change', function() {
            // Revalidate the field when an option is chosen
            validator.revalidateField('country');
        });
	}

	// Handle form validation and submittion
	var handleForm = function() {
		// Stepper custom navigation

		// Init form validation rules. For more info check the FormValidation plugin's official documentation:https://formvalidation.io/
		validator = FormValidation.formValidation(
			form,
			{
				fields: {
					'first-name': {
						validators: {
							notEmpty: {
								message: 'First name is required'
							}
						}
					},
					'last-name': {
						validators: {
							notEmpty: {
								message: 'Last name is required'
							}
						}
					},
					'country': {
						validators: {
							notEmpty: {
								message: 'Country is required'
							}
						}
					},
					'address1': {
						validators: {
							notEmpty: {
								message: 'Address 1 is required'
							}
						}
					},
					'address2': {
						validators: {
							notEmpty: {
								message: 'Address 2 is required'
							}
						}
					},
					'city': {
						validators: {
							notEmpty: {
								message: 'City is required'
							}
						}
					},
					'state': {
						validators: {
							notEmpty: {
								message: 'State is required'
							}
						}
					},
					'postcode': {
						validators: {
							notEmpty: {
								message: 'Postcode is required'
							}
						}
					}
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					bootstrap: new FormValidation.plugins.Bootstrap5({
						rowSelector: '.fv-row',
                        eleInvalidClass: '',
                        eleValidClass: ''
					})
				}
			}
		);

		submitButton.addEventListener('click', function (e) {
			e.preventDefault();
		
			// Validate form before submit
			if (validator) {
				validator.validate().then(function (status) {
					console.log('validated!');
					debugger;
		
					if (status == 'Valid') {
						submitButton.setAttribute('data-kt-indicator', 'on');
		
						// Disable button to avoid multiple clicks
						submitButton.disabled = true;
		
						// Simulate ajax process
						submitButton.removeAttribute('data-kt-indicator');
						const formData = new FormData();
						const contractValue = document.querySelector('input[name="contract_name"]').value;
						const userId = document.getElementById('user-data').getAttribute("data-folder");
						formData.append("user_id", userId);
						formData.append('name', contractValue);
		
						$.ajax({
							url: '/projects',
							type: 'POST',
							data: formData, // Use the FormData object as the data
							processData: false, // Prevent jQuery from processing the data
							contentType: false, // Prevent jQuery from setting the content type
							success: function (data) {
								modal.hide();
								window.location.replace(`/projects/${data.id}/details`);
							},
							error: function (data) {
								console.log("error");
							}
						});
					} else {
						// Show error message.
						Swal.fire({
							text: "Sorry, looks like there are some errors detected, please try again.",
							icon: "error",
							buttonsStyling: false,
							confirmButtonText: "Ok, got it!",
							customClass: {
								confirmButton: "btn btn-primary"
							}
						});
					}
				});
			}
		});
		

		cancelButton.addEventListener('click', function (e) {
			e.preventDefault();

			Swal.fire({
				text: "Are you sure you would like to cancel?",
				icon: "warning",
				showCancelButton: true,
				buttonsStyling: false,
				confirmButtonText: "Yes, cancel it!",
				cancelButtonText: "No, return",
				customClass: {
					confirmButton: "btn btn-primary",
					cancelButton: "btn btn-active-light"
				}
			}).then(function (result) {
				if (result.value) {
					form.reset(); // Reset form	
					modal.hide(); // Hide modal				
				} else if (result.dismiss === 'cancel') {
					Swal.fire({
						text: "Your form has not been cancelled!.",
						icon: "error",
						buttonsStyling: false,
						confirmButtonText: "Ok, got it!",
						customClass: {
							confirmButton: "btn btn-primary",
						}
					});
				}
			});
		});
	}

	return {
		// Public functions
        init: function () {
            // Elements
            form = document.querySelector('#kt_modal_new_address_form');
            submitButton = document.getElementById('kt_modal_new_address_submit');
            cancelButton = document.getElementById('kt_modal_new_address_cancel');

            if (modal) {
                modal.dispose(); // Dispose of the existing modal if it exists
            }

            modal = new bootstrap.Modal(document.querySelector('#kt_modal_new_address'));

            initForm();
            handleForm();
        }
	};
}();

// On document ready
KTUtil.onDOMContentLoaded(function () {
	KTModalNewAddress.init();
});
