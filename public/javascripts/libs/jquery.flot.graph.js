/*! Convenience methods for using flot*/

(function($){
 $.fn.graph = function(options) {
   
   var defaults = {
     format:"%m/%d"
   };
   var options = $.extend(defaults, options);
 
   if(options.format == '%a') {
     var dayFormatter = function(val, axis) {
       var d = new Date(val);
       var dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
       return dayNames[d.getDay()];
     };
     
     options.tickFormatter = dayFormatter;
   }

   return this.each(function() {
     var container = $(this);
     var metrics = container.data('metrics');
     var markers = container.find('.marker').remove();
     
     var flotOptions = {
       grid: { borderWidth: 1, color: '#999999' },
       series: {
         lines: { show: true, lineWidth: options.lineWidth},
         points: { show: true, lineWidth: options.lineWidth, radius: options.radius},
         shadowSize: 0,
         color: '#049CDB'
       },
       xaxis: {mode:"time", timeformat: "%y/%m/%d", tickFormatter: options.tickFormatter},
       yaxis: {tickDecimals:0,min:0}
     };
     var graph = $.plot(this, [metrics], flotOptions);

     markers.each(function() {
       var x = $(this).data('x');
       var y = getValue(x, metrics);
       var point = graph.pointOffset({x: x, y: y});
       $(this).css({position:'absolute', left:point.left + 'px', top: point.top + 'px'});
       container.append(this)
     });     
   });
   
   function getValue(x, metrics) {
     for(var i = 0; i < metrics.length; i++) {
       var dataPoint = metrics[i];
       if(x == dataPoint[0]) return dataPoint[1];
     }
   }
   
 };
})(jQuery);



