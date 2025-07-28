export default class SyncSelect {
  constructor(select_id, options) {
    this.$select = $(select_id)
    this.imageAttr = options['from']
    this.$imageTarget = $(options['toImage'])
    this.$textTarget = $(options['toText'])
    
    this.$select.change(() => this.refresh())
  }
  
  syncImage () {
    if (this.$imageTarget && this.imageAttr) {
      let selected_image_url = this.$select.find('option:selected').attr(this.imageAttr);
      this.$imageTarget.prop('src', selected_image_url || '');
    }
  }
  
  syncText() {
    if (this.$textTarget) {
      let text = this.$select.find('option:selected').text();
      this.$textTarget.text(text);
    }
  }
  
  refresh() {
    if (!this.$select) {
      return;
    }
    
    this.syncImage()
    this.syncText()
  }
}
