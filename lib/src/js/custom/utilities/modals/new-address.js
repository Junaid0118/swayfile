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

		let apiCallInProgress = false; // Initialize a flag variable

submitButton.addEventListener('click', function (e) {
    e.preventDefault();

    // Check if an API call is already in progress
    if (apiCallInProgress) {
        return; // Do nothing if an API call is already in progress
    }

    // Validate form before submit
    if (validator) {
        validator.validate().then(function (status) {
            console.log('validated!');

            if (status == 'Valid') {
                // Set the flag to indicate that an API call is in progress
                apiCallInProgress = true;

                // Simulate ajax process
                const formData = new FormData();
                const contractValue = document.querySelector('input[name="contract_name"]').value;
                const userId = document.getElementById('user-data').getAttribute("data-folder");
                formData.append("user_id", userId);
                formData.append('name', contractValue);
				const folderElement = document.getElementById('folder-data');
				let folderID = null;

				if (folderElement) {
					folderID = folderElement.getAttribute('data-folder');
					formData.append("folder_id", folderID);
				}

                $.ajax({
                    url: '/projects',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (data) {
                        modal.hide();
						window.location.reload();
                        window.location.replace(`/projects/${data.id}/details`);
                    },
                    error: function (data) {
                        console.log("error");
						window.location.reload();
                    },
                    complete: function () {
                        // Reset the flag when the API call is complete
                        // apiCallInProgress = false;
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
					window.location.reload();
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
