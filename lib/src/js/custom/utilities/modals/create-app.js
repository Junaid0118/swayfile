"use strict";

const selectedGuests = [];
const selectedSignotry = [];

// Class definition
var KTCreateApp = function () {
	// Elements
	var modal;	
	var modalEl;

	var stepper;
	var form;
	var formSubmitButton;
	var formContinueButton;

	// Variables
	var stepperObj;
	var validations = [];

	// Private Functions
	var initStepper = function () {
		// Initialize Stepper
		stepperObj = new KTStepper(stepper);

		// Stepper change event(handle hiding submit button for the last step)
		stepperObj.on('kt.stepper.changed', function (stepper) {
			if (stepperObj.getCurrentStepIndex() === 4) {
				formSubmitButton.classList.remove('d-none');
				formSubmitButton.classList.add('d-inline-block');
				formContinueButton.classList.add('d-none');
			} else if (stepperObj.getCurrentStepIndex() === 5) {
				formSubmitButton.classList.add('d-none');
				formContinueButton.classList.add('d-none');
			} else {
				formSubmitButton.classList.remove('d-inline-block');
				formSubmitButton.classList.remove('d-none');
				formContinueButton.classList.remove('d-none');
			}
		});

		// Validation before going to next page
		stepperObj.on('kt.stepper.next', function (stepper) {
			console.log('stepper.next');

			// Validate form before change stepper step
			var validator = validations[stepper.getCurrentStepIndex() - 1]; // get validator for currnt step

			if (validator) {
				validator.validate().then(function (status) {
					console.log('validated!');

					if (status == 'Valid') {
						stepper.goNext();

						//KTUtil.scrollTop();
					} else {
						// Show error message popup. For more info check the plugin's official documentation: https://sweetalert2.github.io/
						Swal.fire({
							text: "Sorry, looks like there are some errors detected, please try again.",
							icon: "error",
							buttonsStyling: false,
							confirmButtonText: "Ok, got it!",
							customClass: {
								confirmButton: "btn btn-light"
							}
						}).then(function () {
							//KTUtil.scrollTop();
						});
					}
				});
			} else {
				stepper.goNext();

				KTUtil.scrollTop();
			}
		});

		// Prev event
		stepperObj.on('kt.stepper.previous', function (stepper) {
			console.log('stepper.previous');

			stepper.goPrevious();
			KTUtil.scrollTop();
		});

		formSubmitButton.addEventListener('click', function (e) {
			// Validate form before changing stepper step
			var validator = validations[3]; // get validator for the last form
		
			validator.validate().then(function (status) {
				console.log('validated!');
		
				if (status == 'Valid') {
					// Prevent default button action
					e.preventDefault();
		
					// Disable button to avoid multiple clicks
					formSubmitButton.disabled = true;
		
					const formData = new FormData();
					const teamMembers = selectedGuests.map(item => item.value);
					const sign_ids = selectedSignotry.map(item => item.value);

					var fileInput = document.getElementById('kt_modal_create_campaign_files_upload');
					var file = fileInput.dropzone.files[0]; // Assuming only one file is allowed
					formData.append('avatar', file);
		
					for (var i = 0; i < form.elements.length; i++) {
						var fieldName = form.elements[i].name;
						var fieldValue = form.elements[i].value;
		
						if (fieldName === 'email' || fieldName === 'phone') {
							continue; // Skip this field
						}
		
						if (fieldName === 'status') {
							fieldValue = form.elements[i].checked ? 'Active' : 'Inactive';
						}
		
						// Append key-value pairs to the FormData object
						formData.append(fieldName, fieldValue);
					}
		
					// Append the teamMembers and role parameters
					formData.append("members", teamMembers.join(","));
					formData.append("sign_ids", sign_ids.join(","));
		
					// Now, 'formData' contains all the form data you need
		
					$.ajax({
						url: '/projects',
						type: 'POST',
						data: formData, // Use the FormData object as the data
						processData: false, // Prevent jQuery from processing the data
						contentType: false, // Prevent jQuery from setting the content type
						success: function (data) {
							window.location.replace("/projects/");
						},
						error: function (data) {
							// Handle error
						}
					});
		
					// Show loading indication
					formSubmitButton.setAttribute('data-kt-indicator', 'on');
		
					// Simulate form submission
					setTimeout(function () {
						// Hide loading indication
						formSubmitButton.removeAttribute('data-kt-indicator');
		
						// Enable button
						formSubmitButton.disabled = false;
		
						stepperObj.goNext();
						// KTUtil.scrollTop();
					}, 2000);
				} else {
					Swal.fire({
						text: "Sorry, looks like there are some errors detected, please try again.",
						icon: "error",
						buttonsStyling: false,
						confirmButtonText: "Ok, got it!",
						customClass: {
							confirmButton: "btn btn-light"
						}
					}).then(function () {
						// KTUtil.scrollTop();
					});
				}
			});
		});		
	}

	// Init form inputs
	var initForm = function() {
		// Expiry month. For more info, plase visit the official plugin site: https://select2.org/
        $(form.querySelector('[name="card_expiry_month"]')).on('change', function() {
            // Revalidate the field when an option is chosen
            validations[3].revalidateField('card_expiry_month');
        });

		const allTagify = form.querySelectorAll('[data-kt-inbox-form="tagify"]');

		// Init tagify
        allTagify.forEach(tagify => {
            initTagify(tagify);
        });

		// Expiry year. For more info, plase visit the official plugin site: https://select2.org/
        $(form.querySelector('[name="card_expiry_year"]')).on('change', function() {
            // Revalidate the field when an option is chosen
            validations[3].revalidateField('card_expiry_year');
        });
	}


	// Updated code with changes
const initTagify = (el) => {
    var inputElm = el;

    // Your hardcoded users list
    const usersList = [];

    // Selected guests list
    function initializeTagify(data) {
        function tagTemplate(tagData) {
            return `
                <tag title="${(tagData.title || tagData.email)}"
                        contenteditable='false'
                        spellcheck='false'
                        tabIndex="-1"
                        class="${this.settings.classNames.tag} ${tagData.class ? tagData.class : ""}"
                        ${this.getAttributes(tagData)}>
                    <x title='' class='tagify__tag__removeBtn' role='button' aria-label='remove tag'></x>
                    <div class="d-flex align-items-center">
                        <div class='tagify__tag__avatar-wrap ps-0'>
                            <img onerror="this.style.visibility='hidden'" class="rounded-circle w-25px me-2" src="${hostUrl}media/${tagData.avatar}">
                        </div>
                        <span class='tagify__tag-text'>${tagData.name}</span>
                    </div>
                </tag>
            `;
        }

        function suggestionItemTemplate(tagData) {
            return `
                <div ${this.getAttributes(tagData)}
                    class='tagify__dropdown__item d-flex align-items-center ${tagData.class ? tagData.class : ""}'
                    tabindex="0"
                    role="option">
    
                    ${tagData.avatar ? `
                            <div class='tagify__dropdown__item__avatar-wrap me-2'>
                                <img onerror="this.style.visibility='hidden'"  class="rounded-circle w-50px me-2" src="${hostUrl}media/${tagData.avatar}">
                            </div>` : ''
            }
    
                    <div class="d-flex flex-column">
                        <strong>${tagData.name}</strong>
                        <span>${tagData.email}</span>
                    </div>
                </div>
            `;
        }

        // Create the Tagify instance with the combined whitelist (initial + API data)
        var tagify = new Tagify(inputElm, {
            tagTextProp: 'name',
            enforceWhitelist: true,
            skipInvalid: true,
            dropdown: {
                closeOnSelect: false,
                enabled: 0,
                classname: 'users-list',
                searchKeys: ['name', 'email']
            },
            templates: {
                tag: tagTemplate,
                dropdownItem: suggestionItemTemplate
            },
            whitelist: data // Use the combined user data
        });

        tagify.on('dropdown:show dropdown:updated', onDropdownShow);
        tagify.on('dropdown:select', onSelectSuggestion);

        var addAllSuggestionsElm;

        function onDropdownShow(e) {
            var dropdownContentElm = e.detail.tagify.DOM.dropdown.content;

            if (tagify.suggestedListItems.length > 1) {
                addAllSuggestionsElm = getAddAllSuggestionsElm();

                dropdownContentElm.insertBefore(addAllSuggestionsElm, dropdownContentElm.firstChild);
            }
        }

		// Function to generate the team members list based on selectedGuests
		function generateTeamMembersList() {
			const teamMembersList = document.getElementById('team-members-list');
			teamMembersList.innerHTML = ''; // Clear previous content

			selectedGuests.forEach((guest) => {
				const userDiv = document.createElement('div');
				userDiv.classList.add('d-flex', 'flex-stack', 'py-4', 'border-bottom', 'border-gray-300', 'border-bottom-dashed');

				// Avatar
				const avatarDiv = document.createElement('div');
				avatarDiv.classList.add('symbol', 'symbol-35px', 'symbol-circle');
				const avatarImg = document.createElement('img');
				avatarImg.setAttribute('alt', 'Pic');
				avatarImg.setAttribute('src', "/assets/media/avatars/300-6.jpg" || 'assets/media/avatars/placeholder.jpg');
				avatarDiv.appendChild(avatarImg);

				// Details
				const detailsDiv = document.createElement('div');
				detailsDiv.classList.add('ms-5');
				const userName = document.createElement('a');
				userName.classList.add('fs-5', 'fw-bold', 'text-gray-900', 'text-hover-primary', 'mb-2');
				userName.textContent = guest.name;
				const userEmail = document.createElement('div');
				userEmail.classList.add('fw-semibold', 'text-muted');
				userEmail.textContent = guest.email;
				detailsDiv.appendChild(userName);
				detailsDiv.appendChild(userEmail);

				// Access menu
				const accessMenuDiv = document.createElement('div');
				accessMenuDiv.classList.add('ms-2', 'w-100px');

				const accessSelect = document.createElement('select');
				accessSelect.classList.add('form-select', 'form-select-solid', 'form-select-sm');
				accessSelect.setAttribute('data-control', 'select2');
				accessSelect.setAttribute('data-hide-search', 'true');

				// Create the dropdown using your template
				const dropdownOptions = [
					{ value: '1', text: 'Guest' },
					{ value: '2', text: 'Owner' },
					{ value: '3', text: 'Can Edit' },
				];

				dropdownOptions.forEach((option) => {
					const optionElement = document.createElement('option');
					optionElement.value = option.value;
					optionElement.textContent = option.text;
					accessSelect.appendChild(optionElement);
				});

				accessMenuDiv.appendChild(accessSelect);

				// Append elements to userDiv
				userDiv.appendChild(avatarDiv);
				userDiv.appendChild(detailsDiv);
				userDiv.appendChild(accessMenuDiv);

				// Append userDiv to teamMembersList
				teamMembersList.appendChild(userDiv);
			});
		}

		function generateSignMembersList() {
			const teamMembersList = document.getElementById('sign-members-list');
			teamMembersList.innerHTML = ''; // Clear previous content

			selectedGuests.forEach((guest) => {
				const userDiv = document.createElement('div');
				userDiv.classList.add('d-flex', 'flex-stack', 'py-4', 'border-bottom', 'border-gray-300', 'border-bottom-dashed');

				// Avatar
				const avatarDiv = document.createElement('div');
				avatarDiv.classList.add('symbol', 'symbol-35px', 'symbol-circle');
				const avatarImg = document.createElement('img');
				avatarImg.setAttribute('alt', 'Pic');
				avatarImg.setAttribute('src', "/assets/media/avatars/300-6.jpg" || 'assets/media/avatars/placeholder.jpg');
				avatarDiv.appendChild(avatarImg);

				// Details
				const detailsDiv = document.createElement('div');
				detailsDiv.classList.add('ms-5');
				const userName = document.createElement('a');
				userName.classList.add('fs-5', 'fw-bold', 'text-gray-900', 'text-hover-primary', 'mb-2');
				userName.textContent = guest.name;
				const userEmail = document.createElement('div');
				userEmail.classList.add('fw-semibold', 'text-muted');
				userEmail.textContent = guest.email;
				detailsDiv.appendChild(userName);
				detailsDiv.appendChild(userEmail);

				// Access menu
				const accessMenuDiv = document.createElement('div');
				accessMenuDiv.classList.add('ms-2', 'w-100px');

				const accessSelect = document.createElement('select');
				accessSelect.classList.add('form-select', 'form-select-solid', 'form-select-sm');
				accessSelect.setAttribute('data-control', 'select2');
				accessSelect.setAttribute('data-hide-search', 'true');

				// Create the dropdown using your template
				const dropdownOptions = [
					{ value: '1', text: 'Guest' },
					{ value: '2', text: 'Owner' },
					{ value: '3', text: 'Can Edit' },
				];

				dropdownOptions.forEach((option) => {
					const optionElement = document.createElement('option');
					optionElement.value = option.value;
					optionElement.textContent = option.text;
					accessSelect.appendChild(optionElement);
				});

				accessMenuDiv.appendChild(accessSelect);

				// Append elements to userDiv
				userDiv.appendChild(avatarDiv);
				userDiv.appendChild(detailsDiv);
				userDiv.appendChild(accessMenuDiv);

				// Append userDiv to teamMembersList
				teamMembersList.appendChild(userDiv);
			});
		}

		function handleMemberInput(inputName, generateFunction) {
			const inputElement = document.querySelector(`input[name="${inputName}"]`);
			
			if (!inputElement) {
				console.error(`Input element with name "${inputName}" not found.`);
				return;
			}
			
			inputElement.addEventListener('input', function() {
				// Check if the input value meets your condition (e.g., not empty)
				if (this.value.trim() !== '') {
					generateFunction();
				} else {
					// Handle the case when the condition is not met (optional)
				}
			});
		}

		function onSelectSuggestion(e) {
			const selectedSuggestion = e.detail.data;
			const inputType = inputElm.getAttribute('data-custom-attribute');
			if(inputType == "project_member"){
				if (!tagify.isTagDuplicate(selectedSuggestion.value)) {
					selectedGuests.push(selectedSuggestion);
				}
				generateTeamMembersList();
			}else{
				if (!tagify.isTagDuplicate(selectedSuggestion.value)) {
					selectedSignotry.push(selectedSuggestion);
				}
				generateSignMembersList();
			}
		}

        function getAddAllSuggestionsElm() {
            return tagify.parseTemplate('dropdownItem', [{
                class: "addAll",
                name: "Add all",
                email: tagify.settings.whitelist.reduce(function (remainingSuggestions, item) {
                    return tagify.isTagDuplicate(item.value) ? remainingSuggestions : remainingSuggestions + 1;
                }, 0) + " Members"
            }]);
        }
    }

    $.ajax({
        url: '/get_users',
        type: 'GET',
        dataType: 'json',
        success: function (apiData) {
            const formattedApiData = apiData.map(user => ({
                value: user.id,
                name: user.last_name,
                avatar: 'avatars/300-6.jpg',
                email: user.email
            }));

            const combinedData = [
                ...usersList,
                ...formattedApiData
            ];

            initializeTagify(combinedData);
        },
        error: function (data) {
            // Handle errors
        }
    });
};

	var initValidation = function () {
		// Init form validation rules. For more info check the FormValidation plugin's official documentation:https://formvalidation.io/
		// Step 1
		validations.push(FormValidation.formValidation(
			form,
			{
				fields: {
					name: {
						validators: {
							notEmpty: {
								message: 'App name is required'
							}
						}
					},
					category: {
						validators: {
							notEmpty: {
								message: 'Category is required'
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
		));

		// Step 2
		validations.push(FormValidation.formValidation(
			form,
			{
				fields: {
					framework: {
						validators: {
							notEmpty: {
								message: 'Framework is required'
							}
						}
					}
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					// Bootstrap Framework Integration
					bootstrap: new FormValidation.plugins.Bootstrap5({
						rowSelector: '.fv-row',
                        eleInvalidClass: '',
                        eleValidClass: ''
					})
				}
			}
		));

		// Step 3
		validations.push(FormValidation.formValidation(
			form,
			{
				fields: {
					dbname: {
						validators: {
							notEmpty: {
								message: 'Database name is required'
							}
						}
					},
					dbengine: {
						validators: {
							notEmpty: {
								message: 'Database engine is required'
							}
						}
					}
				},
				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					// Bootstrap Framework Integration
					bootstrap: new FormValidation.plugins.Bootstrap5({
						rowSelector: '.fv-row',
                        eleInvalidClass: '',
                        eleValidClass: ''
					})
				}
			}
		));

		// Step 4
		validations.push(FormValidation.formValidation(
			form,
			{
				fields: {
					'card_name': {
						validators: {
							notEmpty: {
								message: 'Name on card is required'
							}
						}
					},
					'card_number': {
						validators: {
							notEmpty: {
								message: 'Card member is required'
							},
                            creditCard: {
                                message: 'Card number is not valid'
                            }
						}
					},
					'card_expiry_month': {
						validators: {
							notEmpty: {
								message: 'Month is required'
							}
						}
					},
					'card_expiry_year': {
						validators: {
							notEmpty: {
								message: 'Year is required'
							}
						}
					},
					'card_cvv': {
						validators: {
							notEmpty: {
								message: 'CVV is required'
							},
							digits: {
								message: 'CVV must contain only digits'
							},
							stringLength: {
								min: 3,
								max: 4,
								message: 'CVV must contain 3 to 4 digits only'
							}
						}
					}
				},

				plugins: {
					trigger: new FormValidation.plugins.Trigger(),
					// Bootstrap Framework Integration
					bootstrap: new FormValidation.plugins.Bootstrap5({
						rowSelector: '.fv-row',
                        eleInvalidClass: '',
                        eleValidClass: ''
					})
				}
			}
		));
	}

	return {
		// Public Functions
		init: function () {
			// Elements
			modalEl = document.querySelector('#kt_modal_create_app');

			if (!modalEl) {
				return;
			}

			modal = new bootstrap.Modal(modalEl);

			stepper = document.querySelector('#kt_modal_create_app_stepper');
			form = document.querySelector('#kt_modal_create_app_form');
			formSubmitButton = stepper.querySelector('[data-kt-stepper-action="submit"]');
			formContinueButton = stepper.querySelector('[data-kt-stepper-action="next"]');

			initStepper();
			initForm();
			initValidation();
		}
	};
}();

// On document ready
KTUtil.onDOMContentLoaded(function() {
    KTCreateApp.init();
});