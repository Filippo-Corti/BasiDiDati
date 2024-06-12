<?php

function buildTable($results, $columns, $table = NULL, $actions = false)
{
    //Intestation
    $str = '<table class="w-100">';
    $str .= '<tr>';
    foreach ($columns as $col) {
        $col = ucfirst($col);
        $str .= "<th> {$col} </th>";
    }
    if ($actions) {
        $str .= "<th> Actions </th>";
    }
    $str .= '</tr>';
    foreach ($results as $row) {
        $str .= '<tr><form method="POST" action="opmanager.php">';
        $str .= "<input type='hidden' name='table' value='{$table}'>";
        foreach ($columns as $col) {
            $str .= "<td> <input type='hidden' name='{$col}' value='{$row[$col]}'> {$row[$col]} </td>";
        }
        if ($actions) {
            $str .= "<td><button type='submit' name='operation' value='goto_update' class='btn btn-edit'>Edit</button>
            <button type='submit' name='operation' value='delete' class='btn btn-delete'>Delete</button></td>";
        }
        $str .= '</form></tr>';
    }
    return $str . '</table>';
}

function buildToast($id, $type, $title, $content)
{

    switch ($type) {
        case "success":
            $bgClass = 'success';
            $icon = 'check.svg';
            $appearenceTime = "5000";
            break;
        case "error":
            $bgClass = 'danger';
            $icon = 'exclamation.svg';
            $appearenceTime = "20000";
            break;
        default:
            return;
    }

    return <<<EOD
    <div id="{$id}" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-config='{"delay":{$appearenceTime}}'>
                <div class="toast-header">
                    <div class="rounded me-2 d-flex justify-content-center p-1 bg-{$bgClass}">
                        <img src="img/{$icon}">
                    </div>
                    <strong class="me-auto">{$title}</strong>
                    <small>Just Now</small>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    {$content}
                </div>
            </div>
    EOD;
}

function buildAppointmentsTimeline($appointments)
{
    $str = "";
    foreach ($appointments as $app) {
        $urgency = getUrgencyColor($app['urgenza']);
        $regime = ($app['regimeprivato']) ? "Regime Privato ({$app['costo']}€)" : "Regime Assistenziale ({$app['costo']}€)";
        $str .= <<<EOD
            <div class="tl-item">
                <div class="tl-dot b-{$urgency}"></div>
                <div class="tl-content">
                    <div class="fw-semibold">{$app['descrizione']}</div>
                    <div>Presso {$app['indirizzo']} con {$regime}</div>
                    <div class="tl-date text-muted mt-1">Il {$app['dataesame']} alle {$app['oraesame']}</div>
                </div>
            </div>
    EOD;
    }
    return $str;
}

function buildAppointmentRequestsTable($results) {
    //Intestation
    $str = '<table class="w-100">';
    $str .= '<tr>';
    foreach ($results[0] as $col => $v) {
        $col = ucfirst($col);
        $str .= "<th> {$col} </th>";
    }
    $str .= "<th> Actions </th>";
    $str .= '</tr>';
    foreach ($results as $row) {
        $regimePrivato = ($row['regimeprivato'] == 'Si') ? 't' : 'f';
        $str .= <<<EOD
            <tr>
                <form method="POST" action="opmanager.php">
                    <input type="hidden" name="operation" value="appointment_from_request">
                    <td> <input type='hidden' name='paziente' value='{$row['paziente']}'> {$row['paziente']} </td>
                    <td> <input type='hidden' name='esame' value='{$row['codice']}'> {$row['codice']} </td>
                    <td> {$row['esame']} </td>
                    <td> {$row['descrizione']} </td>
                    <td> <input type='hidden' name='regimeprivato' value='{$regimePrivato}'> {$row['regimeprivato']} </td>
                    <td><button class="btn rounded-pill btn-mine-light" type="submit"><span class="poppins fw-normal"> &gt;</span> Crea una Prenotazione </button></td>
                </form>
            </tr>
        EOD;
    }
    return $str . '</table>';
}


function buildInputText($name, $minsize, $maxsize, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" type="text" name="{$name}" id="{$name}" minlength="{$minsize}" maxlength="{$maxsize}" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputPassword($name, $minsize, $maxsize, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" type="password" name="{$name}" id="{$name}" minlength="{$minsize}" maxlength="{$maxsize}" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputNumber($name, $totalDigits, $decimalDigits, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);
    $maxNumber = pow(10, $totalDigits - $decimalDigits) - 1;
    $decimalPrecision = 1 / pow(10, $decimalDigits);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="number" max="{$maxNumber}" step="{$decimalPrecision}" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputBoolean($name, $required, $editable = true, $checked = false)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $checkedStr = ($checked) ? "checked" : "";

    return <<<EOD
        <label class="form-check-label" for="{$name}">{$name}:</label>
        <input name="{$name}" type="hidden" value="f">
        <input class="form-check-input" name="{$name}" type="checkbox" value="t" {$getRequired} {$getEditable} {$checkedStr}>
        <br>
        <br>
    EOD;
}

function buildInputDate($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="date" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputTime($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="time" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputDateTime($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="datetime-local" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputSelect($name, $options, $required, $editable = true, $value = NULL, $visualizedOptions = null)
{
    if (!$visualizedOptions) {
        $visualizedOptions = $options;
    }

    $getRequired = getRequired($required);
    $getEditable = "";
    $getAlternativeInput = "";
    if (!$editable) {
        $getEditable = "disabled";
        $getAlternativeInput = "<input type='hidden' name='{$name}' value='{$value}'>";
    }

    $optionsStr = "";
    $selected = false;
    $i = 0;
    foreach ($options as $option) {
        if ($option == $value ||  $visualizedOptions[$i] == $value) {
            $optionsStr .= "<option value='{$option}' selected>{$visualizedOptions[$i]}</option>";
            $selected = true;
        } else {
            $optionsStr .= "<option value='{$option}'>{$visualizedOptions[$i]}</option>";
        }
        $i++;
    }

    if (!$selected) {
        $optionsStr = '<option value="" selected>--</option>' . $optionsStr;
    } else {
        $optionsStr = '<option value="">--</option>' . $optionsStr;
    }

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        {$getAlternativeInput}
        <select class="form-select rounded-pill" name="{$name}" id="{$name}" {$getRequired} {$getEditable}>
        {$optionsStr}
        </select>
        <br>
    EOD;
}

function getRequired($r)
{
    return ($r) ? "required" : "";
}

function getEditable($e)
{
    return ($e) ? "" : "readonly";
}

function getValue($v)
{
    return ($v) ? "value='{$v}'" : "";
}

function getUrgencyColor($u)
{
    switch ($u) {
        case 'Rosso':
            return "danger";
        case 'Giallo':
            return "warning";
        case 'Verde':
            return "success";
    }
    return "";
}
