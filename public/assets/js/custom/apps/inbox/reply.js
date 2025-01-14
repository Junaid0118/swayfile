"use strict";
let quill;

// Class definition
var KTAppInboxReply = function () {

    // Private functions
    const handlePreviewText = () => {
        // Get all messages
        const accordions = document.querySelectorAll('[data-kt-inbox-message="message_wrapper"]');
        accordions.forEach(accordion => {
            // Set variables
            const header = accordion.querySelector('[data-kt-inbox-message="header"]');
            const previewText = accordion.querySelector('[data-kt-inbox-message="preview"]');
            const details = accordion.querySelector('[data-kt-inbox-message="details"]');
            const message = accordion.querySelector('[data-kt-inbox-message="message"]');

            // Init bootstrap collapse -- more info: https://getbootstrap.com/docs/5.1/components/collapse/#via-javascript
            const collapse = new bootstrap.Collapse(message, { toggle: false });

            // Handle header click action
            header.addEventListener('click', e => {
                // Return if KTMenu or buttons are clicked
                if (e.target.closest('[data-kt-menu-trigger="click"]') || e.target.closest('.btn')) {
                    return;
                } else {
                    previewText.classList.toggle('d-none');
                    details.classList.toggle('d-none');
                    collapse.toggle();
                }
            });
        });
    }

    // Init reply form
    const initForm = () => {
        // Set variables
        const form = document.querySelector('#kt_inbox_reply_form');
        const allTagify = form.querySelectorAll('[data-kt-inbox-form="tagify"]');

        // Handle CC and BCC
        handleCCandBCC(form);

        // Handle submit form
        handleSubmit(form);

        // Init tagify
        allTagify.forEach(tagify => {
            initTagify(tagify);
        });

        // Init quill editor
        initQuill(form);

        // Init dropzone
        initDropzone(form);
    }

    // Handle CC and BCC toggle
    const handleCCandBCC = (el) => {
        // Get elements
        const ccElement = el.querySelector('[data-kt-inbox-form="cc"]');
        const ccButton = el.querySelector('[data-kt-inbox-form="cc_button"]');
        const ccClose = el.querySelector('[data-kt-inbox-form="cc_close"]');
        const bccElement = el.querySelector('[data-kt-inbox-form="bcc"]');
        const bccButton = el.querySelector('[data-kt-inbox-form="bcc_button"]');
        const bccClose = el.querySelector('[data-kt-inbox-form="bcc_close"]');

        // Handle CC button click
        ccButton.addEventListener('click', e => {
            e.preventDefault();

            ccElement.classList.remove('d-none');
            ccElement.classList.add('d-flex');
        });

        // Handle CC close button click
        ccClose.addEventListener('click', e => {
            e.preventDefault();

            ccElement.classList.add('d-none');
            ccElement.classList.remove('d-flex');
        });

        // Handle BCC button click
        bccButton.addEventListener('click', e => {
            e.preventDefault();

            bccElement.classList.remove('d-none');
            bccElement.classList.add('d-flex');
        });

        // Handle CC close button click
        bccClose.addEventListener('click', e => {
            e.preventDefault();

            bccElement.classList.add('d-none');
            bccElement.classList.remove('d-flex');
        });
    }

    // Handle submit form
    const handleSubmit = (el) => {
        const submitButton = el.querySelector('[data-kt-inbox-form="send"]');

        // Handle button click event
        submitButton.addEventListener("click", function () {

            const clauseContent = quill.getText();
            const clauseTitle =  document.getElementById("clauseName").value;
            const userId = document.getElementById("user-data").getAttribute("data-folder")
            const projectId = document.getElementById("project-data").getAttribute("data-folder")
            // Activate indicator
            submitButton.setAttribute("data-kt-indicator", "on");

            const formData = new FormData();
            formData.append('clause_name', clauseTitle);
            formData.append('clause_content', clauseContent);
            formData.append('user_id', userId);
            formData.append('project_id', projectId);
            

            $.ajax({
                url: `/contracts/${projectId}/clauses`,
                type: 'POST',
                data: formData, // Use the FormData object as the data
                processData: false, // Prevent jQuery from processing the data
                contentType: false, // Prevent jQuery from setting the content type
                success: function (data) {
                    window.location.replace(`/contracts/${projectId}/contract`);
                },
                error: function (data) {
                    console.log("error")
                    
                }
            });

            // Disable indicator after 3 seconds
            setTimeout(function () {
                submitButton.removeAttribute("data-kt-indicator");
            }, 3000);
        });
    }

    // Init tagify 
    const initTagify = (el) => {
        var inputElm = el;
    
        // Your hardcoded users list
        const usersList = [];
    
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
    
            function onSelectSuggestion(e) {
                if (e.detail.elm == addAllSuggestionsElm)
                    tagify.dropdown.selectAll.call(tagify);
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
    

    // Init quill editor 
    const initQuill = (el) => {
        quill = new Quill('#kt_inbox_form_editor', {
            modules: {
                toolbar: [
                  
                ]
            },
            placeholder: 'Type your clause details here...',
        });

        // Customize editor
        const toolbar = el.querySelector('.ql-toolbar');

        if (toolbar) {
            
        }
    }

    // Init dropzone
    const initDropzone = (el) => {

        // set the dropzone container id
        const id = '[data-kt-inbox-form="dropzone"]';
        const dropzone = el.querySelector(id);
        const uploadButton = el.querySelector('[data-kt-inbox-form="dropzone_upload"]');

        // set the preview element template
        var previewNode = dropzone.querySelector(".dropzone-item");
        previewNode.id = "";
        var previewTemplate = previewNode.parentNode.innerHTML;
        previewNode.parentNode.removeChild(previewNode);

        var myDropzone = new Dropzone(id, { // Make the whole body a dropzone
            url: "https://preview.keenthemes.com/api/dropzone/void.php", // Set the url for your upload script location
            parallelUploads: 20,
            maxFilesize: 1, // Max filesize in MB
            previewTemplate: previewTemplate,
            previewsContainer: id + " .dropzone-items", // Define the container to display the previews
            clickable: uploadButton // Define the element that should be used as click trigger to select files.
        });


        myDropzone.on("addedfile", function (file) {
            // Hookup the start button
            const dropzoneItems = dropzone.querySelectorAll('.dropzone-item');
            dropzoneItems.forEach(dropzoneItem => {
                dropzoneItem.style.display = '';
            });
        });

        // Update the total progress bar
        myDropzone.on("totaluploadprogress", function (progress) {
            const progressBars = dropzone.querySelectorAll('.progress-bar');
            progressBars.forEach(progressBar => {
                progressBar.style.width = progress + "%";
            });
        });

        myDropzone.on("sending", function (file) {
            // Show the total progress bar when upload starts
            const progressBars = dropzone.querySelectorAll('.progress-bar');
            progressBars.forEach(progressBar => {
                progressBar.style.opacity = "1";
            });
        });

        // Hide the total progress bar when nothing"s uploading anymore
        myDropzone.on("complete", function (progress) {
            const progressBars = dropzone.querySelectorAll('.dz-complete');

            setTimeout(function () {
                progressBars.forEach(progressBar => {
                    progressBar.querySelector('.progress-bar').style.opacity = "0";
                    progressBar.querySelector('.progress').style.opacity = "0";
                });
            }, 300);
        });
    }


    // Public methods
    return {
        init: function () {
            handlePreviewText();
            initForm();
        }
    };
}();

// On document ready
KTUtil.onDOMContentLoaded(function () {
    KTAppInboxReply.init();
});
