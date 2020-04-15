var items = new Array();
var nodes = document.querySelectorAll('.v-MailboxItem, .is-unread');
for(i = 0; i < nodes.length; i++) {
    var a = nodes[i];
    var itemHREF = a.href;
    var itemFrom = a.querySelector('.v-MailboxItem-name').innerText;
    var itemSubject = a.querySelector('.v-MailboxItem-subject').innerText;
    var obj = {itemHREF: itemHREF, itemFrom: itemFrom, itemSubject: itemSubject};
    items.push(obj);
}
items;
