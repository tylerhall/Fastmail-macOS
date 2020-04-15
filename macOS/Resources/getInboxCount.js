var getNextSibling = function (elem, selector) {

    // Get the next sibling element
    var sibling = elem.nextElementSibling;

    // If the sibling matches our selector, use it
    // If not, jump to the next sibling and continue the loop
    while (sibling) {
        if (sibling.matches(selector)) return sibling;
        sibling = sibling.nextElementSibling
    }

};

var inboxSource = document.querySelector('span.app-source-name');
var badge = getNextSibling(inboxSource, 'span');
badge.innerText;
