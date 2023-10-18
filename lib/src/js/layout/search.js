"use strict";

// Class definition
var KTLayoutSearch = (function () {
  // Private variables
  var element;
  var formElement;
  var mainElement;
  var resultsElement;
  var wrapperElement;
  var emptyElement;

  var preferencesElement;
  var preferencesShowElement;
  var preferencesDismissElement;

  var advancedOptionsFormElement;
  var advancedOptionsFormShowElement;
  var advancedOptionsFormCancelElement;
  var advancedOptionsFormSearchElement;

  var searchObject;

  // Private functions
  var processs = function (search) {
    var timeout = setTimeout(function () {
      var number = KTUtil.getRandomInt(1, 3);

      // Hide recently viewed
      mainElement.classList.add("d-none");

      if (number === 3) {
        // Hide results
        resultsElement.classList.add("d-none");
        // Show empty message
        emptyElement.classList.remove("d-none");
      } else {
        // Show results
        resultsElement.classList.remove("d-none");
        // Hide empty message
        emptyElement.classList.add("d-none");
      }

      // Complete search
      search.complete();
    }, 1500);
  };

  var processsAjax = function (search) {
    // Hide recently viewed
    mainElement.classList.add("d-none");

    // Learn more: https://axios-http.com/docs/intro
    $.ajax({
      url: `/search_projects?query=${search.getQuery()}`,
      type: "GET",
      processData: false,
      contentType: false,
      success: function (data) {
        // Parse the JSON response if it's in JSON format
        // data = JSON.parse(data);

        // Clear existing content in resultsElement
        resultsElement.innerHTML = "";
        debugger;

        // Iterate through the data and create fragments
        data.forEach(function (item) {
          // Create a new div element
          var fragment = document.createElement("div");
          fragment.className = "d-flex align-items-center mb-5";

          // Create the Symbol div
          var symbolDiv = document.createElement("div");
          symbolDiv.className = "symbol symbol-40px me-4";
          symbolDiv.innerHTML =
            '<span class="symbol-label bg-light"><i class="ki-outline ki-laptop fs-2 text-primary"></i></span>';

          // Create the Title div
          var titleDiv = document.createElement("div");
          titleDiv.className = "d-flex flex-column";
          titleDiv.innerHTML =
          '<a href="/projects/' + item[1] + '" class="fs-6 text-gray-800 text-hover-primary fw-semibold">' +
          item[0] +
          '</a><span class="fs-7 text-muted fw-semibold">#' +
          item[1] +
          '</span>';        

          // Append symbolDiv and titleDiv to the fragment
          fragment.appendChild(symbolDiv);
          fragment.appendChild(titleDiv);

          fragment.addEventListener("click", function () {
            window.location.href = "/projects/" + item[1];
          });
    

          // Append the fragment to resultsElement
          resultsElement.appendChild(fragment);
        });

        // Show results
        resultsElement.classList.remove("d-none");
        // Hide empty message
        emptyElement.classList.add("d-none");

        // Complete search
        search.complete();
      },
      error: function (data) {
        // Handle the error as needed

        // Hide results
        resultsElement.classList.add("d-none");
        // Show empty message
        emptyElement.classList.remove("d-none");

        // Complete search
        search.complete();
      },
    });
  };

  var clear = function (search) {
    // Show recently viewed
    mainElement.classList.remove("d-none");
    // Hide results
    resultsElement.classList.add("d-none");
    // Hide empty message
    emptyElement.classList.add("d-none");
  };

  var handlePreferences = function () {
    // Preference show handler
    preferencesShowElement.addEventListener("click", function () {
      wrapperElement.classList.add("d-none");
      preferencesElement.classList.remove("d-none");
    });

    // Preference dismiss handler
    preferencesDismissElement.addEventListener("click", function () {
      wrapperElement.classList.remove("d-none");
      preferencesElement.classList.add("d-none");
    });
  };

  var handleAdvancedOptionsForm = function () {
    // Show
    advancedOptionsFormShowElement.addEventListener("click", function () {
      wrapperElement.classList.add("d-none");
      advancedOptionsFormElement.classList.remove("d-none");
    });

    // Cancel
    advancedOptionsFormCancelElement.addEventListener("click", function () {
      wrapperElement.classList.remove("d-none");
      advancedOptionsFormElement.classList.add("d-none");
    });

    // Search
    advancedOptionsFormSearchElement.addEventListener("click", function () {});
  };

  // Public methods
  return {
    init: function () {
      // Elements
      element = document.querySelector("#kt_header_search");

      if (!element) {
        return;
      }

      wrapperElement = element.querySelector(
        '[data-kt-search-element="wrapper"]',
      );
      formElement = element.querySelector('[data-kt-search-element="form"]');
      mainElement = element.querySelector('[data-kt-search-element="main"]');
      resultsElement = element.querySelector(
        '[data-kt-search-element="results"]',
      );
      emptyElement = element.querySelector('[data-kt-search-element="empty"]');

      preferencesElement = element.querySelector(
        '[data-kt-search-element="preferences"]',
      );
      preferencesShowElement = element.querySelector(
        '[data-kt-search-element="preferences-show"]',
      );
      preferencesDismissElement = element.querySelector(
        '[data-kt-search-element="preferences-dismiss"]',
      );

      advancedOptionsFormElement = element.querySelector(
        '[data-kt-search-element="advanced-options-form"]',
      );
      advancedOptionsFormShowElement = element.querySelector(
        '[data-kt-search-element="advanced-options-form-show"]',
      );
      advancedOptionsFormCancelElement = element.querySelector(
        '[data-kt-search-element="advanced-options-form-cancel"]',
      );
      advancedOptionsFormSearchElement = element.querySelector(
        '[data-kt-search-element="advanced-options-form-search"]',
      );

      // Initialize search handler
      searchObject = new KTSearch(element);

      // Demo search handler
      // searchObject.on("kt.search.process", processs);

      // Ajax search handler
      searchObject.on("kt.search.process", processsAjax);

      // Clear handler
      searchObject.on("kt.search.clear", clear);

      // Custom handlers
      handlePreferences();
      handleAdvancedOptionsForm();
    },
  };
})();

// On document ready
KTUtil.onDOMContentLoaded(function () {
  KTLayoutSearch.init();
});
