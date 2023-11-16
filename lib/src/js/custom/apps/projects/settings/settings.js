"use strict";

// Class definition
var KTProjectSettings = function () {

    // Private functions
    var handleForm = function () {
        // Init Datepicker --- For more info, please check Flatpickr's official documentation: https://flatpickr.js.org/
        $("#kt_datepicker_1").flatpickr();
        // Form validation
        var validation;
        var _form = document.getElementById('kt_project_settings_form');
        var submitButton = _form.querySelector('#kt_project_settings_submit');

        // Init form validation rules. For more info check the FormValidation plugin's official documentation:https://formvalidation.io/
        validation = FormValidation.formValidation(
            _form,
            {
                fields: {
                    name: {
                        validators: {
                            notEmpty: {
                                message: 'Project name is required'
                            }
                        }
                    },
                },
                plugins: {
                    trigger: new FormValidation.plugins.Trigger(),
                    submitButton: new FormValidation.plugins.SubmitButton(),
                    //defaultSubmit: new FormValidation.plugins.DefaultSubmit(), // Uncomment this line to enable normal button submit after form validation
                    bootstrap: new FormValidation.plugins.Bootstrap5({
                        rowSelector: '.fv-row'
                    })
                }
            }
        );

        submitButton.addEventListener('click', function (e) {
            e.preventDefault();
            var form = document.getElementById('kt_project_settings_form');
            validation.validate().then(function (status) {
                if (status == 'Valid') {
                    var newName = document.getElementById('project_name').value;
                    var projectId = document.getElementById('project-data').getAttribute("data-project");
                    var params = '';
                    params += "name" + "=" + newName
                    $.ajax({
                        url:`/contracts/${projectId}?`+params,
                        type:'PUT',
                        dataType:'json',
                        success:function(data){
                            swal.fire({
                                text: "Thank you! You've updated your project settings",
                                icon: "success",
                                buttonsStyling: false,
                                confirmButtonText: "Ok, got it!",
                                customClass: {
                                    confirmButton: "btn fw-bold btn-light-primary"
                                }
                            }).then(function () {
                                window.location.replace(`/contracts/${projectId}/details`);
                            });
                        },
                        error:function(data){
                            swal.fire({
                                text: "Sorry, looks like there are some errors detected, please try again.",
                                icon: "error",
                                buttonsStyling: false,
                                confirmButtonText: "Ok, got it!",
                                customClass: {
                                    confirmButton: "btn fw-bold btn-light-primary"
                                }
                            });
                        }
                    });
                } else {
                    swal.fire({
                        text: "Sorry, looks like there are some errors detected, please try again.",
                        icon: "error",
                        buttonsStyling: false,
                        confirmButtonText: "Ok, got it!",
                        customClass: {
                            confirmButton: "btn fw-bold btn-light-primary"
                        }
                    });
                }
            });
        });
    }

    // Public methods
    return {
        init: function () {
            handleForm();
        }
    }
}();


// On document ready
KTUtil.onDOMContentLoaded(function() {
    KTProjectSettings.init();
});
