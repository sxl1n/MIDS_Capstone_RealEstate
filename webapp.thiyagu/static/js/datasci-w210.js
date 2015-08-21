
function ZipProject()
{
    this.ShowPriceChart = function(a_url)
    {
        $("#chart-pane table tbody td").html("<img src=\"" + a_url + "\"></src>");
        $("#chart-pane").show();
    }

    this.SetUpChart = function()
    {
        $("#myTable button").click(function(a_eventObj) {
            zip_project.ShowPriceChart(a_eventObj.target.name);
            return true;
        });

        document.getElementById('myTable').scrollIntoView({block: "start", behavior: "smooth"});

		$("#chart-pane button").bind('click', function () {
			$('#chart-pane').hide();
		});

		$(document).keydown(function(a_eventObj) {
			a_eventObj = a_eventObj || window.event;
			if ( a_eventObj.keyCode == 27 ) {
				$('#chart-pane').hide();
			}
		});
    }
}

var zip_project = new ZipProject();
$(window).load(zip_project.SetUpChart);

