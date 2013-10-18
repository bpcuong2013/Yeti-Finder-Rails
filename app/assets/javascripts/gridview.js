// colModel is array of JSON with structure: field, display, width, align, template, key, visible, sortField, customTemplateFunc, customSelectedFieldInVisibleFunc
function GridView(container, colModel, data, emptyString, sortField, sortDirection) {
    this.container = container;
    this.colModel = colModel;
    this.data = data;
    this.emptyString = emptyString;
    this.rowClickEvent = null;
    this.gridId = "";
    this.selectionChangedEvent = null;
    this.sortField = sortField;
    this.sortDirection = sortDirection;
    this.sortEvent = null;

    this.build = function () {
        var html;
        var header = "";
        var body = "";

        //display: "<input type='checkbox' id='selectAll' class='selectAll' />", width: "5%", align: "center", template: "<input type='checkbox' messageId='{Id}' id='select_{Id}' class='select' />"
        this.gridId = getRandomString();
        for (var i = 0; i < this.colModel.length; i++) {
            if (this.colModel[i].isSelectedField) {
                this.colModel[i].align = "center";
                header += "<th width='" + this.colModel[i].width + "' class='grid_header'><input type='checkbox' id='selectAll_" + this.gridId + "' class='selectAll_" + this.gridId + "' title='Select all' /></th>";
            }
            else {
                if (this.colModel[i].visible != null && this.colModel[i].visible != undefined && !this.colModel[i].visible) {
                    continue;
                }

                var sortFieldAttr = "";
                var content = this.colModel[i].display;
                if (this.colModel[i].sortField != null && this.colModel[i].sortField != undefined && this.colModel[i].sortField != "") {
                    sortFieldAttr = "sortField='" + this.colModel[i].sortField + "'";
                    var sort_indicator = "";
                    if (this.colModel[i].sortField == this.sortField) {
                        sort_indicator = " grid_sort_up";
                        if (this.sortDirection == "Desc") {
                            sort_indicator = " grid_sort_down";
                        }
                    }

                    content = "<div class='header_text'>" + this.colModel[i].display + "</div><div class='header_sort_indicator" + sort_indicator + "'></div>";
                }

                header += "<th width='" + this.colModel[i].width + "' class='grid_header' " + sortFieldAttr + ">" + content + "</th>";
            }
        }

        header = "<tr>" + header + "</tr>";
        var hasData = false;
        if (this.data == null || this.data.length == 0) {
            body = "<tr><td colspan='" + this.colModel.length + "' class='empty_row cell-center' align='center'>" + this.emptyString + "</td></tr>";
        }
        else {
            hasData = true;
            for (var row = 0; row < this.data.length; row++) {
                var rowHtml = "";
                var keyValue = null;
                for (var col = 0; col < this.colModel.length; col++) {
                    if (this.colModel[col].isSelectedField) {
                        var showCheckbox = true;
                        if (this.colModel[col].customSelectedFieldInVisibleFunc != null && this.colModel[col].customSelectedFieldInVisibleFunc != undefined) {
                            showCheckbox = !this.colModel[col].customSelectedFieldInVisibleFunc(this.data[row]);
                        }

                        if (showCheckbox) {
                            this.colModel[col].template = "<input type='checkbox' key='{" + this.colModel[col].keyField + "}' class='select_" + this.gridId + "' id='select_" + this.gridId + "_" + row + "' />";
                        }
                    }

                    var val = "";
                    if (this.colModel[col].field != null && this.colModel[col].field != undefined) {
                        val = this.data[row][this.colModel[col].field];
                        if (this.colModel[col].key) {
                            keyValue = val;
                        }
                    }
                    else {
                        if (this.colModel[col].template != null && this.colModel[col].template != undefined) {
                            val = this.colModel[col].template;
                        }
                        else if (this.colModel[col].customTemplateFunc != null && this.colModel[col].customTemplateFunc != undefined) {
                            val = this.colModel[col].customTemplateFunc(this.data[row]);
                        }

                        if (val != "" && val != undefined) {
                        	var regex = new RegExp(/\{[a-z,A-Z,_]?[a-z,A-Z,_,0-9,.]*\}/);
                            do {
                                var fieldExpr = val.match(regex);
                                if (fieldExpr != null) {
                                    var field = fieldExpr.toString().replace("{", "").replace("}", "");
                                    var runtimeVal = eval("this.data[row]." + field);
                                    if (runtimeVal == null || runtimeVal == undefined) {
                                        runtimeVal = "";
                                    }

                                    val = val.replace(fieldExpr.toString(), runtimeVal);
                                }
                            } while (fieldExpr != null);
                        }
                    }

                    if (this.colModel[col].visible != null && this.colModel[col].visible != undefined && !this.colModel[col].visible) {
                        continue;
                    }

                    if (val == null) {
                        val = "";
                    }

                    var align = this.colModel[col].align;
                    if (align == null || align == undefined) {
                        align = "left";
                    }

                    var alignCss = "cell-" + align;
                    rowHtml += "<td align='" + align + "' class='" + alignCss + "'>" + val + "</td>";
                }

                rowHtml = "<tr key='" + keyValue + "' class='data_row' id='row_" + this.gridId + "_" + keyValue + "'>" + rowHtml + "</tr>";
                body += rowHtml;
            }
        }

        html = "<table class='grid_view' id='gridView_" + this.gridId + "'>" + header + body + "</table>";
        this.container.html(html);
        $("table.grid_view tr.data_row:odd").addClass("grid_row");
        $("table.grid_view tr.data_row:even").addClass("grid_row_alternate");

        if (hasData) {
            $("table.grid_view th.grid_header").click(function () {
                if (aThis.sortEvent != null) {
                    if ($(this).attr("sortField") != null && $(this).attr("sortField") != undefined) {
                        if (aThis.sortField != $(this).attr("sortField")) {
                            aThis.sortDirection = "Desc";
                        }

                        aThis.sortField = $(this).attr("sortField");
                        $("table.grid_view th.grid_header div.header_sort_indicator").removeClass("grid_sort_down");
                        $("table.grid_view th.grid_header div.header_sort_indicator").removeClass("grid_sort_up");
                        if (aThis.sortDirection == "Asc") {
                            aThis.sortDirection = "Desc";
                            jQuery(this).find("div.header_sort_indicator").addClass("grid_sort_down");
                        }
                        else {
                            aThis.sortDirection = "Asc";
                            jQuery(this).find("div.header_sort_indicator").addClass("grid_sort_up");
                        }

                        aThis.sortEvent(aThis.sortField, aThis.sortDirection);
                    }
                }
            });

            $("table.grid_view tr.data_row").hover(function () {
                $(this).addClass("grid_row_hover");
            },
            function () {
                $(this).removeClass("grid_row_hover");
            });

            var aThis = this;
            $("table.grid_view tr.data_row").click(function () {
                if (aThis.rowClickEvent != null) {
                    aThis.rowClickEvent($(this).attr("key"));
                }
            });

            this.makeSelection(this.gridId, this.data);
        }
    };

    this.makeSelection = function (result) {
        // Bold the row which is unread
        var checkBoxRowIdPrefix = "#select_" + this.gridId;
        var checkBoxHeaderId = "#selectAll_" + this.gridId;
        var checkBoxRow = "input.select_" + this.gridId;
        for (var i = 0; i < result.length; i++) {
            if (!result[i].IsRead) {
                $(checkBoxRowIdPrefix + "_" + i).parent().parent().addClass("bold");
            }
        }

        var aThis = this;
        // Register the selection
        $(checkBoxHeaderId).click(function () {
            if (isNullOrEmpty($(this).attr("checked"))) {
                $(checkBoxRow).removeAttr("checked");
            }
            else {
                $(checkBoxRow).attr("checked", $(this).attr("checked"));
            }

            if ($(this).attr("checked")) {
                $(checkBoxRow).parent().parent().addClass("grid_row_selected");
            }
            else {
                $(checkBoxRow).parent().parent().removeClass("grid_row_selected");
            }

            if (aThis.selectionChangedEvent != null) {
                aThis.selectionChangedEvent(aThis.getSelectedRowCount());
            }
        });

        $(checkBoxRow).click(function (e) {
            if ($(this).attr("checked")) {
                $(this).parent().parent().addClass("grid_row_selected");
            }
            else {
                $(this).parent().parent().removeClass("grid_row_selected");
            }

            // synchronize the selection between rows and header checkboxes
            var selectCheckboxes = $(checkBoxRow);
            var allChecked = true;
            for (var j = 0; j < selectCheckboxes.length; j++) {
                if (!$(selectCheckboxes.get(j)).attr("checked")) {
                    allChecked = false;
                    break;
                }
            }

            $(checkBoxHeaderId).attr("checked", allChecked);
            e.stopPropagation();

            if (aThis.selectionChangedEvent != null) {
                aThis.selectionChangedEvent(aThis.getSelectedRowCount());
            }
        });
    };

    this.getSelectedKeys = function () {
        var selectedIds = "";
        var selectCheckboxes = $("input.select_" + this.gridId);
        for (var i = 0; i < selectCheckboxes.length; i++) {
            if ($(selectCheckboxes.get(i)).attr("checked")) {
                selectedIds += "," + $(selectCheckboxes.get(i)).attr("key");
            }
        }

        if (selectedIds != "") {
            return selectedIds.substring(1);
        }

        return "";
    };

    this.getSelectedRows = function () {
        var selectedRows = new Array();
        var selectCheckboxes = $("input.select_" + this.gridId);
        for (var i = 0; i < selectCheckboxes.length; i++) {
            if ($(selectCheckboxes.get(i)).attr("checked")) {
                selectedRows.push($(selectCheckboxes.get(i)).parent().parent());
            }
        }

        return selectedRows;
    };

    this.getSelectedRowCount = function () {
        var count = 0;
        var selectCheckboxes = $("input.select_" + this.gridId);
        for (var i = 0; i < selectCheckboxes.length; i++) {
            if ($(selectCheckboxes.get(i)).attr("checked")) {
                count++;
            }
        }

        return count;
    };

    this.removeRow = function (key) {
        $("#row_" + this.gridId + "_" + key).remove();
    };

    this.isEmptyData = function () {
        return $("#gridView_" + this.gridId + " tr.data_row").length == 0;
    };

    // Call
    this.build();
}